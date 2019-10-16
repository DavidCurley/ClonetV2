cwlVersion: v1.0
class: CommandLineTool
id: clonetv2

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: 'curleyd/clonetv2:2.1'
- class: InlineJavascriptRequirement 
- class: ResourceRequirement
  ramMin: 32000
  coresMin: 8

baseCommand: [Rscript]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      mkdir $(inputs.ouput_basename)_results

      Rscript #Somewhere here I need to input my script that runs the inputs
      --Tumor



inputs:

outputs:

