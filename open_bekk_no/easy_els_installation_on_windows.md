## Get set - getting Scoop

[Scoop](http://scoop.sh/) is a brilliant package manager for Windows. It is very command line oriented, which makes it ideal for automating the installation process. It is written in PowerShell and is therefore easy to get started with on any
newer Windows installation. (If you have not done anything serious in PowerShell on your computer, note that you need to run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` once in a shell running as administrator.) Here's a one-liner to install Scoop:
```posh
iex (new-object net.WebClient).DownloadString('https://get.scoop.sh')
```
Any you are all set.

## Ready - loading your toolbox

To get the show on the road, you need to install a few tools. First, `sudo` is a handy tool to run a script as administrator - similar to what you would do in *nix. Next, Scoop uses the concept of a bucket which is a container for applications that you can install. Scoop comes with a build-in bucket and with an 'extras' bucket. We need to enable the latter manually, and for that we need to install Git. Let's install the tools and get add the bucket:
```posh
scoop install sudo git
scoop bucket add extras
```
Now that was easy. You are now ready to go.

## Go! - Install and configure
In this example, we will install two related applications: ElasticSearch and Kibana. Kibana is a graphical user interface for visualizing data in ElasticSearch. First, lets install and configure ElasticSearch

### Install and configure ElasticSearch
Installing is simple. Scoop has the possibility to either install an application for the current user, or install 'globally' for all users. Since ElasticSearch is a server application, it makes sense to install it 'globally'. Scoop needs to run as administrator to install global applications, and we need to add the `--global` parameter to the command. Let's go:
```posh
sudo scoop install elasticsearch --global
```
Now that ElasticSearch is installed, let's define a Windows service to run it, and start it:
```posh
elssrv install
elssrv start
```
That's it. Now ElasticSearch should be accessible on http://localhost:9200.
### Install and configure Kibana
Let's install Kibana, the web-based data visualization tool for ElasticSearch. This is just as simple as installing ElasticSearch itself:
```posh
sudo scoop install kibana --global
```
Then we create the Windows service for it, and start it:
```posh
kibanasrv install
kibanasrv start
```
Now, you have Kibana running at http://localhost:8080.
## Summary
Now, to drive the point home, let's summarize everything to get a comprehensive script to do all the work:
```posh
iex (new-object net.WebClient).DownloadString('https://get.scoop.sh')
scoop install sudo git
scoop bucket add extras
sudo scoop install elasticsearch --global
elssrv install
elssrv start
sudo scoop install kibana --global
kibanasrv install
kibanasrv start
```




