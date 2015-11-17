# On CentOS, epel-release is available in the default repositories.  Therefore,
# ius-release can just resolve the dependency automatically.  On RHEL (or other
# RHEL clones) you will need to explicitly install epel-release first.  This
# state declaration can be moved to it's own state if you want to be able to
# require it independently of the IUS state declaration.

{% if grains['os'] == 'RedHat' %}
'EPEL release package':
  pkg.installed:
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-{{ grains['osmajorrelease'] }}.noarch.rpm
{% endif %}

# Install the appropriate ius-release package.

'IUS release package':
  pkg.installed:
    - sources:
      {% set os = 'centos' if grains['os'] == 'CentOS' else 'rhel' -%}
      - ius-release: https://{{ os }}{{ grains['osmajorrelease'] }}.iuscommunity.org/ius-release.rpm
    {% if not grains['os'] == 'CentOS' -%}
    - requires:
      - pkg: 'EPEL release package'
    {% endif %}
