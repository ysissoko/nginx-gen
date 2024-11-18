
# **NginxGen**  
*A Simple, Dynamic Nginx Configuration File Generator*

NginxGen is a utility built with Plop.js that generates dynamic Nginx reverse proxy configuration files for multiple applications. It allows you to quickly set up reverse proxies, assign subdomains, and enable SSL certificates, all based on your input.

---

## **Features**
- Generate reverse proxy configurations for multiple applications.
- Assign unique subdomains to each application.
- Support for SSL certificates (Let's Encrypt or custom).
- Automatic redirection from HTTP to HTTPS.
- Easily customizable templates for your specific needs.

---

## **Prerequisites**
1. **Node.js** installed on your system.
2. **Nginx** installed and configured to use the generated configuration file.
3. SSL certificates (e.g., from Let's Encrypt) for your subdomains.

---

## **Installation**
Clone or download this repository.
    ```bash
    git clone https://github.com/yourusername/nginxgen.git
    cd nginxgen
   ```

---

## **Usage**

1. Run the generator using Plop.js:
   ```bash
   npx plop
   ```

2. Follow the prompts to configure your Nginx file:
    - The input data filename with your servers configurations

3. After completing the prompts, the configuration file will be generated at:
   ```
   output/nginx.conf
   output/config
   ```

4. Move the generated `output/nginx.conf` file to your Nginx configuration directory (e.g., `/etc/nginx/conf.d/`):
   ```bash
   sudo mv output/nginx.conf /etc/nginx/conf.d/your-config.conf
   ```
5. Move the generated `output/conf` file to your ssh configuration folder (e.g., `~/.ssh`):
   ```bash
   sudo mv output/config ~/.ssh/config
   ```

6. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
   
---

## **Customization**

The generator uses Handlebars templates located in the `plop-templates/` directory. To modify the default behavior:
1. Edit the `nginx-config.hbs` or `ssh-config.hbs` files to change how the configuration is generated.
2. Customize SSL settings, HTTP-to-HTTPS redirection, or other directives as needed.

---

## **Example**

Here’s an example input:
- **Server details**:
   ```json
    [
        {
            "name": "app1",
            "host": "127.0.0.1",
            "port": "3001",
            "domain": "app2.mansadev.com",
            "certFilepath": "path/to/cert/fullchain.pem",
            "privKeyFilepath": "path/to/privkey/privatekey.pem"
        },
        {
            "name": "app2",
            "host": "127.0.0.1",
            "port": "3002",
            "domain": "app2.mansadev.com",
            "certFilepath": "path/to/cert/fullchain.pem",
            "privKeyFilepath": "path/to/privkey/privatekey.pem"
        }
    ]
   ```

Generated output:
```nginx
http {
    upstream app1 {
        server 127.0.0.1:3001;
    }

    upstream app2 {
        server 127.0.0.1:3002;
    }

    server {
        listen 443 ssl;
        server_name app1.yourdomain.com;
        ssl_certificate /path/to/your/app1/fullchain.pem;
        ssl_certificate_key /path/to/your/app1/privkey.pem;

        location / {
            proxy_pass http://app1;
        }
    }

    server {
        listen 443 ssl;
        server_name app2.yourdomain.com;
        ssl_certificate /path/to/your/app2/fullchain.pem;
        ssl_certificate_key /path/to/your/app2/privkey.pem;

        location / {
            proxy_pass http://app2;
        }
    }
}
```

---

## **License**
This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## **Contributing**
We welcome contributions! If you have ideas or improvements, feel free to submit a pull request or open an issue.
