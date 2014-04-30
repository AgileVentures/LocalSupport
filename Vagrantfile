# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.provision "shell", path: "vagrant-ubuntu-install.sh", privileged: false
  config.vm.network :forwarded_port, host: 3003, guest: 3000
  config.vm.synced_folder ".", "/LocalSupport"
end
