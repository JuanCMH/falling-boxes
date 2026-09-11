FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates net-tools procps \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fL -o /tmp/xampp.run "https://downloads.sourceforge.net/project/xampp/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run" \
 && chmod +x /tmp/xampp.run \
 && /tmp/xampp.run --mode unattended --unattendedmodeui none \
 && rm /tmp/xampp.run

RUN sed -i 's/^#\(LoadModule headers_module\)/\1/' /opt/lampp/etc/httpd.conf \
 && printf '\n<DirectoryMatch "^/opt/lampp/htdocs/(modelo|skins)">\n    Header set Access-Control-Allow-Origin "*"\n</DirectoryMatch>\n' >> /opt/lampp/etc/httpd.conf

COPY index.html /opt/lampp/htdocs/index.html
COPY modelo/ /opt/lampp/htdocs/modelo/
COPY skins/ /opt/lampp/htdocs/skins/

EXPOSE 80

CMD ["/bin/bash", "-c", "sed -i \"s/^Listen 80$/Listen ${PORT:-80}/\" /opt/lampp/etc/httpd.conf && /opt/lampp/lampp startapache && tail -F /opt/lampp/logs/error_log"]
