[Scoop](http://scoop.sh/) is a brilliant command line installer for Windows, akin to apt-get and yum on other platforms. You might be familiar with [Chocolatey](https://chocolatey.org/), which is quite similar to Scoop. Personally I found Scoop very easy to get started with. I also found it very easy to contribute to it by adding application installation scripts. (You can find an opinionated comparison between Scoop and Chocolatey [here](https://github.com/lukesampson/scoop/wiki/Chocolatey-Comparison).)

## Get set - getting Scoop

Scoop is very command line oriented, which makes it ideal for automating the installation process. It is written in PowerShell and is therefore easy to get started with on any
newer Windows installation. (If you have not done anything serious in PowerShell on your computer, note that you need to run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` once in a shell running as administrator.) Here's a one-liner to install Scoop:
```posh
iex (new-object net.WebClient).DownloadString('https://get.scoop.sh')
```
## Ready - loading your toolbox

To get the show on the road, you need to install a few tools. First, `sudo` is a handy tool to run a script as administrator - similar to what you would do in *nix. Next, Scoop uses the concept of a bucket which is a container for applications that you can install. Scoop comes with a build-in bucket and with an 'extras' bucket. We need to enable the latter manually, and for that we need to install Git. Let's install the tools and get add the bucket:
```posh
scoop install sudo git
scoop bucket add extras
```
## Go! - Install and configure
In this example, we will install two related applications: [Elasticsearch](http://www.elasticsearch.org/overview/) and [Kibana](http://www.elasticsearch.org/overview/kibana/). Kibana is a graphical user interface for visualizing data in Elasticsearch. First, lets install and configure Elasticsearch

### Install and configure Elasticsearch
Installing is simple. Scoop has the possibility to either install an application for the current user, or install 'globally' for all users. Since Elasticsearch is a server application, it makes sense to install it 'globally'. Scoop needs to run as administrator to install global applications, and we need to add the `--global` parameter to the command.
```posh
sudo scoop install elasticsearch --global
```
Now that Elasticsearch is installed, let's define a Windows service to run it, and start it:
```posh
elssrv install
elssrv start
```
Now Elasticsearch should be accessible on http://localhost:9200.
### Install and configure Kibana
Kibana is a very nice tool for querying and visualizing data in Elasticsearch. It is a Javascript-based web application and the distribution is just the web application files that needs to be served by a web server. When I decided to use Scoop for Elasticsearch installation, there were no installation script for Kibana in Scoop. Luckily, it was very easy to add it as the Scoop source files and application lists are maintained on GitHub. With the new installation definition in place, here's how you install Kibana:
```posh
sudo scoop install kibana --global
```
Then we create the Windows service for it, and start it:
```posh
kibanasrv install
kibanasrv start
```
Now, you have Kibana running at http://localhost:8080.
<img src="https://bekkopen.blob.core.windows.net/attachments/d2742c59-86bd-4e35-8d9a-f4323bb13814" style="width:100%;margin-left:0" />
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
Here is what it looks like if you run it all:
<img src="https://bekkopen.blob.core.windows.net/attachments/d2483cf6-1d82-441f-906d-ac18bd752a98" style="width:100%;margin-left:0" />

[Here](https://raw.githubusercontent.com/vidarkongsli/www_kongsli_net/master/open_bekk_no/install_els_and_kibana.ps1) is the entire PowerShell script that you can run if you wish to get started right away. Alternatively, use this one-liner to install Elasticsearch and Kibana: `iex (new-object net.WebClient).DownloadString('http://kongs.li/elsinst')`.


