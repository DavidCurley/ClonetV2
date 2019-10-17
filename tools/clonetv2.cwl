cwlVersion: v1.0
class: CommandLineTool
id: clonetv2

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: 'davidcurley/clonetv2:2.1'
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

      Rscript -e ""
      
      input_seg_file: seg_file
      input_control: ASEQ_normal_pileup/pileup_file
      input_sample: ASEQ_sample_pileup/pileup_file


inputs:
  input_seg_file: File
  input_control: File
  input_sample: File
outputs:
  beta_table:
    type: File
    outputBinding:
      glob: '*beta_table.txt'
  stats_file:
    type: File
    outputBinding:
      glob: '*stats_file.txt'
  ploidy_admixture:
    type: File
    outputBinding:
      glob: '*ploidy_admixture.txt'
  ploidy_admixture_plot:
    type: File
    outputBinding:
      glob: '*ploidy_admixture_plot.pdf'
  allele_spec_scna:
    type: File
    outputBinding:
      glob: 'allele_spec_scna.pdf'
  scna_clonality:
    type: File
    outputBinding:
      glob: 'scna_clonality.pdf'

