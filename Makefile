VERSION = 0.20.0
ITERATION = 0
UID ?= 0

all: build

build: download
	chmod -Rv 644 build/contrib/
	fpm -s dir -f -t deb \
		-n alertmanager \
		-v $(VERSION) \
		--iteration $(ITERATION) \
		--after-install build/contrib/alertmanager.postinstall \
		--after-remove build/contrib/alertmanager.postrm \
		-p build/packages \
		/tmp/alertmanager/alertmanager=/usr/bin/ \
		/tmp/alertmanager/amtool=/usr/bin/ \
		build/contrib/alertmanager.service=/lib/systemd/system/alertmanager.service \
		build/contrib/alertmanager.defaults=/etc/default/alertmanager \
		build/contrib/alertmanager.preset=/usr/lib/systemd/system-preset/alertmanager.preset \
		/tmp/alertmanager/alertmanager.yml=/etc/alertmanager/alertmanager.yml


download:
	cd /tmp && curl -Lo alertmanager.tar.gz https://github.com/prometheus/alertmanager/releases/download/v$(VERSION)/alertmanager-$(VERSION).linux-amd64.tar.gz
	cd /tmp && tar -xvzf /tmp/alertmanager.tar.gz && mv alertmanager-$(VERSION).linux-amd64 alertmanager
