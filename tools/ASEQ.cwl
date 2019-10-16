cwlVersion: v1.0
class: CommandLineTool
id: aseq
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'curleyd/clonetv2:2.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 12000
    coresMin: