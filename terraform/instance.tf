resource "google_compute_instance" "default" {
  name         = "laravel-app"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  tags = ["http-server", "https-server", "lb-health-check", "nest-app"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    sudo su
    sudo apt-get update
    sudo apt-get install -y curl gnupg

    # Install PHP and necessary extensions
    sudo apt-get install -y php php-cli php-fpm php-mysql php-xml php-mbstring git
    sudo apt-get install -y lsb-release apt-transport-https ca-certificates
    sudo wget -O - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
    echo "deb https://packages.sury.org/php/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/php.list
    sudo apt-get update
    sudo apt-get install -y php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring git
    lsb_release -cs
    sudo update-alternatives --set php /usr/bin/php8.2

    # Install Composer
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

    # Install Node.js 21
    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo bash -
    sudo apt-get install -y nodejs git

    # Clone the repository and set permissions
    sudo git clone https://github.com/SiThuKyawTint-GuGu/laravel-gcp.git /home/guguskyler/laravel-app
    sudo chown -R guguskyler:guguskyler /home/guguskyler/laravel-app
    sudo chmod -R 755 /home/guguskyler/laravel-app

    # Install dependencies and start the app
    cd /home/guguskyler/laravel-app
    composer install
    php artisan serve --host=0.0.0.0 --port=8000
   SCRIPT
}
