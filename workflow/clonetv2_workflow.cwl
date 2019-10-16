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
  output_basename: string
  reference: {type: File, doc: "input reference fasta"}
  threads: {type: ['null', int], default: 16}


outputs:

steps:
  samtools_sample_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_sample
      reference: reference
    out: [bam_file]
  
  samtools_normal_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_control
      reference: reference
    out: [bam_file]

  ASEQ_sample_pileup:
    run: ../tools/ASEQ.cwl
    in:
      input_reads: samtools_sample_cram2bam/bam_file
      input_paired_vcf: input_paired_vcf
    out: [pileup_file]

  ASEQ_normal_pileup:
    run: ../tools/ASEQ.cwl
    in:
      input_reads: samtools_normal_cram2bam/bam_file
      input_paired_vcf: input_paired_vcf
    out: [pileup_file]

  clonetv2:
    run: ../tools/clonetv2.cwl
    in:
      input_seg_file: seg_file
      input_control: ASEQ_normal_pileup/pileup_file
      input_sample: ASEQ_sample_pileup/pileup_file
hints:
- class: 'sbg:maxNumberOfParallelInstances'
  value: 2