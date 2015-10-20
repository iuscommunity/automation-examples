# Install epel on RHEL as the epel-release package is included in the CentOS
# repositories.  Depending on your needs, this might need to be moved to a
# separate state.

{% if grains['os'] == 'RedHat' %}
install_epel_rpm:
  pkg.installed:
    - name: epel-release
    - sources:
      {% if grains['osmajorrelease'][0] == '6' %}
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
      {% elif grains['osmajorrelease'][0] == '7' %}
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      {% endif %}
{% endif %}

# Install the appropriate ius-release package.

{% if grains['os'] == 'CentOS' %}
install-ius-rpm:
  pkg.installed:
    - name: ius-release
    - sources:
      {% if grains['osmajorrelease'][0] == '6' %}
      - ius-release: https://centos6.iuscommunity.org/ius-release.rpm
      {% elif grains['osmajorrelease'][0] == '7' %}
      - ius-release: https://centos7.iuscommunity.org/ius-release.rpm
      {% endif %}
{% endif %}

{% if grains['os'] == 'RedHat' %}
install-ius-rpm:
  pkg.installed:
    - name: ius-release
    - sources:
      {% if grains['osmajorrelease'][0] == '6' %}
      - ius-release: https://rhel6.iuscommunity.org/ius-release.rpm
      {% elif grains['osmajorrelease'][0] == '7' %}
      - ius-release: https://rhel7.iuscommunity.org/ius-release.rpm
      {% endif %}
    - requires:
      - pkg: install_epel_rpm
{% endif %}

