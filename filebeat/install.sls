{% from "filebeat/default.yml" import lookup, rawmap with context %}
{% set lookup = salt['grains.filter_by'](lookup, grain='os', merge=salt['pillar.get']('filebeat:lookup')) %}
{% set rawmap = salt['pillar.get']('filebeat', rawmap) %}

{% if salt['grains.get']('os_family') == 'Debian' %}
apt_https_transport:
    pkg.latest:
       - name: apt-transport-https
{% endif %}

filebeat_repo:
    pkgrepo.managed:
        - humanname: Filebeat Repository
        {% if salt['grains.get']('os') == 'CentOS' %}
        - baseurl: {{lookup.repo_url}}
        - gpgkey: {{lookup.gpg_url}}
        {% else %}
        - name: {{lookup.repo_url}}
        - dist: stable
        - key_url: {{lookup.gpg_url}}
        {% endif %}
        - file: {{lookup.repo_file}}
        - gpgcheck: 1
        - refresh_db: True
        {% if salt['grains.get']('os_family') == 'Debian' %}
        - require:
            - pkg: apt_https_transport
        {% endif %}

filebeat_package:
    pkg.installed:
        - name: {{lookup.package}}
        - require:
            - pkgrepo: filebeat_repo
