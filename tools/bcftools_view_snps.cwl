cwlVersion: v1.0
class: CommandLineTool
id: bcftools_view_snps

requirements: 
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'kfdrc/bvcftools:latest'
  - class: ResourceRequirement
    ramMin: 1000
    coresMin: 1
  - class: InlineJavascriptRequirement

baseCommand: [bcftools view]
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.input_vcf.path) 
      - i $(inputs.include_expression)
      - v snps

inputs:
  input_vcf: File
  include_expression: ['null', string]
  exclude_expression: ['null', string]
  output_basename: string
outputs:
  filtered_vcf:
    type: File
    outputBinding:
      glob: '*.vcf.gz'
    secondaryFiles: [.tbi]
