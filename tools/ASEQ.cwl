cwlVersion: v1.0
class: CommandLineTool
id: aseq
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'davidcurley/clonetv2:2.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 12000
    coresMin: 8

baseCommand: [gunzip -c]
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.filtered_paired_vcf.path) > $(inputs.filtered_paired_vcf.nameroot) ;

      /clonetv2/binaries/linux64/ASEQ 
      mode=PILEUP
      vcf=$(inputs.filtered_paired_vcf.nameroot)
      bam=$(inputs.input_reads.path)
      mbq=20 
      mrq=20 
      mdc=1 
      threads=8
      out=. 

inputs: 
  filtered_paired_vcf: File
  input_reads: File
  threads:
    type: ['null', int]
    default: 16

outputs:
  pileup_file:
    type: File
    outputBinding:
      glob: '*.PILEUP.ASEQ'