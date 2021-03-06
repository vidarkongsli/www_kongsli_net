# Setting up WCF with message security over HTTPS

I can see two possible questions that might pop up in hour head when you read the title of this post. The first one is: _why would you want to do that?_ and the second is _why, that should not be too difficult, should it?_ OK, there might be a third question: _wait, what?_ Let's answer them in reverse order.

## Wait, what?
The case where we needed this kind of configuration, was an application that offered three web services to a third party application. Windows Communication Foundation (WCF) was used on both sides of the integration, running Microsoft .NET 4.5. We wanted to have the web services secured (authentication, encryption and data integrity), and decided on using message security for this (frankly, earlier on we tried to use one-way message security + HTTPS, but we never got that to work in our infrastructure. Elsewere, in a parallell universe, that might have sufficed). When having established message security with certificate authentication in both directions, we wanted to run this over an HTTPS endpoint.

## Why, that should not be too difficult, should it?

No, you would expect not. But alas. We have yet to find any way to do this using an out-of-the-box configuration, using one of the built in bindings. 


## Why would you want to do that?
Our application is Internet facing, and we are running WCF inside the ASP.NET process in IIS. We did not want to set up an HTTP endpoint in IIS, in the firewall and the loadbalancer just for the WCF services. Rather, we would like to keep the site being an always-HTTPs site. We thus wanted to expose the service on an HTTPs endpoint altough security was taken care of using message security and SSL being terminated by the load balancer. An extra layer, would not hurt, right?

## Fiddler to the rescue!
A scenario like the one described above can be hard to achieve without having an environment with load balancer in place. Luckily, Fiddler can be used to simulate the work of the load balancer. We made it possible to "terminate" SSL in Fiddler just like it would be done on the load balancer by follwing the steps in this post (https://yorkporc.wordpress.com/2014/02/17/using-fiddler-as-a-ssl-terminating-load-balancer/).

## So, give me the details
As mentioned we decided on using message security and we also made all configurations in c# as apposed to web.confg.
First the server side:

```cs
//create a custom binding
var binding = new CustomBinding(new WSHttpBinding
{
	Security =
	{
		Mode = SecurityMode.Message,
		Message =
		{
			ClientCredentialType = MessageCredentialType.Certificate,
			NegotiateServiceCredential = false,
            EstablishSecurityContext = false
		}
	}
});

//initialize and add the service endpoint
var endpointUri = new Uri("applicationbaseuri", "the service uri");
var listenUriBuilder = new UriBuilder(endpointUri)
{
	Scheme = "http",
	Port = 80
};

config.AddServiceEndpoint(contractType, binding, endpointUri, listenUriBuilder.Uri);

//configure serticifate
config.Credentials.ServiceCertificate.SetCertificate(StoreLocation.LocalMachine, StoreName.My, X509FindType.FindByThumbprint,"insert certificate thumbprint here");
config.Credentials.ClientCertificate.Authentication.CertificateValidationMode = X509CertificateValidationMode.PeerOrChainTrust;
config.Credentials.ClientCertificate.Authentication.RevocationMode = X509RevocationMode.NoCheck;

//set behaviour
config.Description.Behaviors.Add(new ServiceMetadataBehavior
{
	HttpGetEnabled = true
});
```

Simliarly, the client side:
```cs
var endpointUri = new Uri("application base uri", "service uri");
var endpointAddress = new EndpointAddress(endpointUri, new DnsEndpointIdentity("issuedto from public certificate provided from server"));

var binding = new CustomBinding(new WSHttpBinding
{
	Security =
	{
		Mode = SecurityMode.Message,
		Message =
		{
			ClientCredentialType = MessageCredentialType.Certificate,
			NegotiateServiceCredential = false,
            EstablishSecurityContext = false
		},
		Transport =
		{
			ClientCredentialType = HttpClientCredentialType.None
		}
	}
});

//Because SSL is terminated at the load balancer we also needed to do some adjustmenst (also called a hack) to trick WCF into accepting an HTTPS binding even when securitymode is only set to Message
var httpTransport = binding.Elements.Find<HttpTransportBindingElement>();
var index = binding.Elements.IndexOf(httpTransport);
binding.Elements.Remove<HttpTransportBindingElement>();
binding.Elements.Insert(index, new HttpsTransportBindingElement());

var factory = new ChannelFactory<TChannel>(binding, endpointAddress);
factory.Credentials.ClientCertificate.SetCertificate(
	StoreLocation.LocalMachine,
	StoreName.My,
	X509FindType.FindByThumbprint,
	"insert client certificate thumbprint here");

factory.Credentials.ServiceCertificate.SetDefaultCertificate(StoreLocation.LocalMachine,
	StoreName.TrustedPeople, X509FindType.FindByThumbprint, "insert server certificate thumbprint here");
```

## Suggestions, improvements?
