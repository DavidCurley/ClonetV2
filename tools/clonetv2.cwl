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

baseCommand: []
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      Rscript -e "Library(CLONETv2)"

      Rscript -e "seg_tb <- read.table('$(input_seg_file.path)', header = TRUE, as.is = TRUE)" ;
      Rscript -e "pileup_tumor <- read.table('$(input_sample.path)', header = TRUE, as.is = TRUE)" ;
      Rscript -e "pileup_normal <- read.table('$(input_control.path)', header = TRUE, as.is = TRUE)" ;

      Rscript -e "sink('beta_table.txt')"
      Rscript -e "bt <- compute_beta_table(seg_tb,pileup_tumor,pileup_normal)"
      Rscript -e "sink()"

      Rscript -e "sink('stats_file.txt')"
      Rscript -e "statbt <- compute_beta_table(seg_tb,pileup_tumor,pileup_normal, plot_stats=T)"
      Rscript -e "sink()"

      Rscript -e "sink('ploidy_admixture.txt')"
      Rscript -e "pl <- compute_ploidy(bt)"

      Rscript -e "adm <- compute_dna_admixture(bt,pl)"
      Rscript -e "sink()"

      Rscript -e "pdf('ploidy_admixture_plot.pdf')"
      Rscript -e "check_plot <- check_ploidy_and_admixture(bt,pl,adm)"
      Rscript -e "print(check_plot)"
      Rscript -e "dev.off()"

      Rscript -e "pdf('allele_specific_scna.pdf')"
      Rscript -e "as_tb <‐ compute_allele_specific_scna_table(bt, pl, adm)"
      Rscript -e "print(as_tb)"
      Rscript -e "dev.off()"

      Rscript -e "pdf('scna_clonality.pdf')"
      Rscript -e "clonality_tb <‐ compute_scna_clonality_table(bt, pl, adm)"
      Rscript -e "print(clonality_tb)"
      Rscript -e "dev.off()"

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

