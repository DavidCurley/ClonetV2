cwlVersion: v1.0
class: CommandLineTool
id: clonetv2

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: 'davidcurley/clonetv2:2.1'
- class: InlineJavascriptRequirement 
- class: ResourceRequirement
  ramMin: 8000
  coresMin: 4

baseCommand: []
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      Rscript -e "library(CLONETv2)

      seg_tb <- read.table('$(inputs.input_seg_file.path)', header = TRUE, as.is = TRUE) ;
      pileup_tumor <- read.table('$(inputs.input_sample.path)', header = TRUE, as.is = TRUE) ;
      pileup_normal <- read.table('$(inputs.input_control.path)', header = TRUE, as.is = TRUE) ;

      sink('beta_table.txt') ;
      bt <- compute_beta_table(seg_tb,pileup_tumor,pileup_normal) ;
      bt ;
      sink() ;

      sink('stats_file.txt') ;
      statbt <- compute_beta_table(seg_tb,pileup_tumor,pileup_normal,plot_stats=T) ;
      statbt ;
      sink() ;

      sink('ploidy_admixture.txt') ;
      pl <- compute_ploidy(bt) ;
      pl ;
      adm <- compute_dna_admixture(bt,pl) ;
      adm ;
      sink() ;

      pdf('ploidy_admixture_plot.pdf') ;
      check_plot <- check_ploidy_and_admixture(bt,pl,adm) ;
      print(check_plot) ;
      dev.off() ;

      sink('allele_specific_scna.txt') ;
      as_tb <- compute_allele_specific_scna_table(bt,pl,adm) ;
      as_tb ;
      sink() ;

      sink('scna_clonality.txt') ;
      clonality_tb <- compute_scna_clonality_table(bt,pl,adm) ;
      clonality_tb ;
      sink() " 

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
      glob: 'allele_specific_scna.txt'
  scna_clonality:
    type: File
    outputBinding:
      glob: 'scna_clonality.txt'

