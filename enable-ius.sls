'EPEL release package':
  pkg.installed:
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-{{ grains['osmajorrelease'] }}.noarch.rpm

'IUS release package':
  pkg.installed:
    - sources:
      - ius-release: https://repo.ius.io/ius-release-el{{ grains['osmajorrelease'] }}.rpm
