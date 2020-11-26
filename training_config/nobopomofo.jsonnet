local model_name = "bert-base-chinese";
local max_length = 512;
local bert_dim = 768;
local encoder_dim = bert_dim;
local decoder_dim = 128;
local data_base_url = "https://storage.googleapis.com/allennlp-public-data/cnndm-combined-data-2020.07.13.tar.gz";
local train_data = "data/train.txt";
local dev_data = "data/dev.txt";
local test_data = "data/test.txt";

{
    "train_data_path": train_data,
    "validation_data_path": dev_data,
    "test_data_path": test_data,
    "dataset_reader": {
        "type": "seq2seq",
        "delimiter": "|",
        "source_tokenizer": {
            "type": "pretrained_transformer",
            "model_name": model_name
        },
        "target_tokenizer": {
            "type": "whitespace",
        },
        "source_token_indexers": {
            "tokens": {
                "type": "pretrained_transformer",
                "model_name": model_name,
                "max_length": max_length,
            },
        },
        "target_token_indexers": {
            "tokens": {
                "type": "single_id"
            },
        },
        "source_add_start_token": false,
        "source_add_end_token": false,
        "src_start_symbol": "",
        "src_end_symbol": "",
        // "max_instances": 1000 // DEBUG setting
    },
    "model": {
        "type": "composed_seq2seq",
        "source_text_embedder" : {
            "token_embedders": {
                "tokens": {
                    "type": "pretrained_transformer",
                    "model_name": model_name,
                    "max_length": max_length,
                },
            }
        },
        "encoder": {
            "type": "feedforward",
            "feedforward": {
                "input_dim": encoder_dim,
                "hidden_dims": decoder_dim,
                "num_layers": 1,
                "activations": "linear",
            }
        },
        "decoder": {
            "type": "auto_regressive_seq_decoder",
            "token_based_metric": {
                "type": "wer",
                "exclude_indices": ["@@START@@", "@@END@@", "@@PADDING@@"],
            },
            "decoder_net": {
                "type": "stacked_self_attention",
                "decoding_dim": decoder_dim,
                "target_embedding_dim": decoder_dim,
                "feedforward_hidden_dim": decoder_dim,
                "num_layers": 4,
                "num_attention_heads": 16,
                "use_positional_encoding": true,
                "positional_encoding_max_steps": 128,
                "dropout_prob": 0.1,
                "residual_dropout_prob": 0.2,
                "attention_dropout_prob": 0.1,
            },
            "max_decoding_steps": 128,
            "target_embedder": {
                "embedding_dim": decoder_dim,
            },
            "tie_output_embedding": true,
        },
    },
    "data_loader": {
        "batch_size": 32,
        "shuffle": true
    },
    "trainer": {
        "num_epochs": 100,
        "optimizer": {
            "type": "adamw",
            "lr": 1e-3,
            "betas": [0.9, 0.999],
            "eps": 1e-8,
            "parameter_groups": [
                [[".*transformer.*"], {"requires_grad": false}]
            ]
        },
        "learning_rate_scheduler": {
          "type": "reduce_on_plateau",
          "factor": 0.5,
          "mode": "max",
          "patience": 1
        },
        "grad_norm": 5.0,
    }
}
