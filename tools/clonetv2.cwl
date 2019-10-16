cwlVersion: v1.0
class: CommandLineTool
id: clonetv2

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull:
- class: InlineJavascriptRequirement 
- class: ResourceRequirement
  ramMin: 32000
  coresMin: 8

baseCommand: []

arguments:


inputs:

outputs:

