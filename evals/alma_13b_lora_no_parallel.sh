OUTPUT_DIR=${1:-"./outputs-alma-13b-lora/"}
TEST_PAIRS=${2:-"de-en,cs-en,is-en,zh-en,ru-en,en-de,en-cs,en-is,en-zh,en-ru"}

python \
    run_llmmt.py \
    --model_name_or_path haoranxu/ALMA-13B-Pretrain \
    --do_predict \
    --low_cpu_mem_usage \
    --language_pairs ${TEST_PAIRS} \
    --mmt_data_path ./human_written_data/ \
    --per_device_eval_batch_size 2 \
    --output_dir ${OUTPUT_DIR} \
    --use_peft \
    --peft_model_id  haoranxu/ALMA-13B-Pretrain-LoRA \
    --predict_with_generate \
    --max_new_tokens 256 \
    --max_source_length 256 \
    --fp16 \
    --seed 42 \
    --num_beams 5 \
    --overwrite_cache \
    --overwrite_output_dir \
    --multi_gpu_one_model

if [[ ${TEST_PAIRS} == *zh-en* ]]; then
    python \
        run_llmmt.py \
        --model_name_or_path haoranxu/ALMA-13B-Pretrain \
        --do_predict \
        --low_cpu_mem_usage \
        --language_pairs zh-en \
        --mmt_data_path ./human_written_data/ \
        --per_device_eval_batch_size 2 \
        --output_dir ${OUTPUT_DIR} \
        --use_peft \
        --peft_model_id  haoranxu/ALMA-13B-Pretrain-LoRA \
        --predict_with_generate \
        --max_new_tokens 256 \
        --max_source_length 512 \
        --fp16 \
        --seed 42 \
        --num_beams 5 \
        --overwrite_cache \
        --overwrite_output_dir \
        --multi_gpu_one_model
fi

## Evaluation (BLEU, COMET)
bash ./evals/eval_generation.sh ${OUTPUT_DIR} ${TEST_PAIRS}
