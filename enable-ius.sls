# On CentOS, epel-release is available in the default repositories.  Therefore,
# ius-release can just resolve the dependency automatically.  On RHEL (or other
# RHEL clones) you will need to explicitly install epel-release first.  This
# state declaration can be moved to it's own state if you want to be able to
# require it independently of the IUS state declaration.

{% if grains['os'] == 'RedHat' %}
install_epel_rpm:
  pkg.installed:
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
    - sources:
      {% if grains['osmajorrelease'][0] == '6' %}
      - ius-release: https://rhel6.iuscommunity.org/ius-release.rpm
      {% elif grains['osmajorrelease'][0] == '7' %}
      - ius-release: https://rhel7.iuscommunity.org/ius-release.rpm
      {% endif %}
    - requires:
      - pkg: install_epel_rpm
{% endif %}

