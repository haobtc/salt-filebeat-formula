{% from "filebeat/default.yml" import lookup, rawmap with context %}
{% set lookup = salt['grains.filter_by'](lookup, grain='os', merge=salt['pillar.get']('filebeat:lookup')) %}
{% set rawmap = salt['pillar.get']('filebeat', rawmap) %}

filebeat_config:
    file.managed:
        - name: {{lookup.config_file}}
        - source: salt://filebeat/files/filebeat.yml.jinja
        - template: jinja
        - context:
            config: {{rawmap}}

filebeat_nginx_module_config:
    file.managed:
        - name: {{lookup.nginx_config_file}}
        - source: salt://filebeat/files/nginx.yml.jinja
        - template: jinja
        - context:
            config: {{rawmap}}
