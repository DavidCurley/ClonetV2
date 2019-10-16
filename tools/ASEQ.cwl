cwlVersion: v1.0
class: CommandLineTool
id: aseq
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'curleyd/clonetv2:2.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 32000
    coresMin:8

baseCommand: [./binaries/linux64/ASEQ]
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      --mode PILEUP
      --vcf $(inputs.input_paired_vcf.path)
      --bam $(inputs.input_reads.path)
      --mbq 20 #minumum bases w/ quality <20 ignored
      --mrq 20 #minimum reads quality <20 ignored
      --mdc 1 #Ignores positions in bam file with zero reads
      --threads 1
      --out . 

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