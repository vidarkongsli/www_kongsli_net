get-command scoop -ErrorAction continue 2>&1 | out-null
if (!$?) { iex (new-object net.WebClient).DownloadString('https://get.scoop.sh') }
scoop install sudo git
scoop bucket add extras
sudo scoop install elasticsearch --global
elssrv install
elssrv start
sudo scoop install kibana --global
kibanasrv install
kibanasrv start
