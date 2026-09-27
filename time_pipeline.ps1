# time_pipeline.ps1
param(
    [string]$Task,
    [string]$Model,
    [string]$Agent,
    [string]$Method = "b1-one-shot"
)

$logFile = "timing_log.csv"
if (-not (Test-Path $logFile)) {
    "task,agent,model,phase,duration_seconds,timestamp" | Out-File $logFile
}

$tGen = Measure-Command {
    python generate_skills.py --task $Task --methods $Method --models $Model --overwrite-configs
}
"$Task,$Agent,$Model,generation,$($tGen.TotalSeconds),$(Get-Date -Format o)" | Out-File -Append $logFile

$tEval = Measure-Command {
    python evaluate_skills.py $Task --judge-model openai/gpt-oss-120b `
        --skill-path "output/skill_generation_results/$Method-$Model" `
        --model $Model --agent $Agent --max-workers 2
}
"$Task,$Agent,$Model,evaluation,$($tEval.TotalSeconds),$(Get-Date -Format o)" | Out-File -Append $logFile