# Terraform summary action

Github Action that generates a job summary from a Terraform plan output file.

The idea is to highlight the number of changes planned to be applied while giving the possibility to view the terraform plan output only.

## Example

<div align=center>
    <img alt="Job summary example" src="./readme-assets/job-summary.png?raw=true" width="80%"/>
</div>

## Usage

```yml
- name: Terraform Plan
  run: terraform plan | tee terraform_plan_output.txt

- name: Print job summary
  uses: sgametrio/terraform-summary-action@main
  with:
    log-file: terraform_plan_output.txt
    # Optional
    title: Custom header in the Job summary
```

## Tests

Tested with Terraform:

- v1.3.6
