Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.boot_timeout = 600

  config.vm.define "prestashop" do |ps|
    ps.vm.hostname = "ImanolSanchezPrestashop"
    ps.vm.network "forwarded_port", guest: 80, host: 8080
    ps.vm.network "forwarded_port", guest: 443, host: 8443
    ps.vm.network "private_network", ip: "192.168.56.30"

    ps.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "2048"
      vb.cpus = 1
    end

    ps.vm.provision "shell", path: "scripts/install_lamp.sh"
    ps.vm.provision "shell", path: "scripts/setup_letsencrypt_https.sh"
    ps.vm.provision "shell", path: "scripts/deploy_prestashop.sh"
  end
end