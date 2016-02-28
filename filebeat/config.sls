{% from "filebeat/default.yml" import lookup, rawmap with context %}
{% set lookup = salt['grains.filter_by'](lookup, grain='os', merge=salt['pillar.get']('filebeat:lookup')) %}
{% set rawmap = salt['pillar.get']('filebeat', rawmap, merge=True) %}

filebeat_config:
    file.managed:
        - name: {{lookup.config_file}}
        - source: salt://filebeat/files/filebeat.yml.j2
        - template: jinja
        - context:
            config: {{rawmap}}
