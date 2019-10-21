cwlVersion: v1.0
class: CommandLineTool
id: aseq
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'davidcurley/clonetv2:2.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 4

baseCommand: [./binaries/linux64/ASEQ]
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      mode=PILEUP
      vcf=$(inputs.input_paired_vcf.path)
      bam=$(inputs.input_reads.path)
      mbq=20 
      mrq=20 
      mdc=1 
      threads=1
      out=. 

inputs: 
  input_paired_vcf: File
  input_reads: File
  threads:
    type: ['null', int]
    default: 16

outputs:
  pileup_file:
    type: File
    outputBinding:
      glob: '*.PILEUP.ASEQ'