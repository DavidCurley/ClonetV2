cwlVersion: v1.0
class: Workflow
id: clonetv2-wf

requirements:
- class: ScatterFeatureRequirement
- class: MultipleInputFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  input_seg_file: {type: File}
  input_sample: {type: File, doc: "Sample bam for pileup"}
  input_control: {type: File, doc: "Normal bam for pileup"}
  input_paired_vcf: {type: File, doc: "Paired VCF for pileup"}
  threads: int
  reference: {type: File, doc: "input reference fasta"}
  output_basename: {type: string}
  include_expression: {type: ['null', string], doc: "In case vcf file needs to be filtered on pass, etc"}

outputs:
  beta_table: {type: File, outputSource: clonetv2/beta_table}
  stats_file: {type: File, outputSource: clonetv2/stats_file}
  ploidy_admixture: {type: File, outputSource: clonetv2/ploidy_admixture}
  ploidy_admixture_plot: {type: File, outputSource: clonetv2/ploidy_admixture_plot}
  allele_spec_scna: {type: File, outputSource: clonetv2/allele_spec_scna}
  scna_clonality: {type: File, outputSource: clonetv2/scna_clonality}

steps:
  samtools_sample_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_sample
      input_threads: threads
      reference: reference
    out: [bam_file]
  
  samtools_normal_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_control
      input_threads: threads
      reference: reference
    out: [bam_file]

  bcftools_view_snps:
    run: ../tools/bcftools_view_snps.cwl
    in:
      input_vcf: input_paired_vcf
      include_expression: include_expression
      output_basename: output_basename
    out:
      [filtered_vcf]

  ASEQ_sample_pileup:
    run: ../tools/ASEQ.cwl
    in:
      input_reads: samtools_sample_cram2bam/bam_file
      filtered_paired_vcf: bcftools_view_snps/filtered_vcf
    out: [pileup_file]

  ASEQ_normal_pileup:
    run: ../tools/ASEQ.cwl
    in:
      input_reads: samtools_normal_cram2bam/bam_file
      filtered_paired_vcf: bcftools_view_snps/filtered_vcf
    out: [pileup_file]

  clonetv2:
    run: ../tools/clonetv2.cwl
    in:
      input_seg_file: input_seg_file
      input_control: ASEQ_normal_pileup/pileup_file
      input_sample: ASEQ_sample_pileup/pileup_file
    out: [beta_table, stats_file, ploidy_admixture, ploidy_admixture_plot, allele_specific_scna, scna_clonality]

$namespaces:
  sbg: https://sevenbridges.com

hints:
  - class: sbg:maxNumberOfParallelInstances
    value: 2