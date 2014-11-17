Easy ElasticSearch installation on Windows


## Get set - getting Scoop

[Scoop](http://scoop.sh/) is a brilliant package manager for Windows. It is very command line oriented, which makes it ideal for automating the installation process. It is written in PowerShell and is therefore easy to get started with on any
newer Windows installation. (If you have not done anything serious in PowerShell on your computer, note that you need to run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` in a shell running as administrator.) Here's a one-liner to install Scoop:
```posh
iex (new-object net.WebClient).DownloadString('https://get.scoop.sh')
```
Any you are ready to go.

## Ready - loading your toolbox

To get the show on the road, you need to install some tools. First, sudo is a handy tool to run a script as administrator - similar to what you would do in *nix. Next, Scoop uses the concept of a bucket which is a container for applications that you can install. Scoop comes with a build-in bucket and with an 'extras' bucket. We need to enable the latter manually, and for that we need to install Git.  