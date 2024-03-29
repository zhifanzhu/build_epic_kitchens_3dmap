# merge images and masks, copy database, then continue here with new registration
# images: contains ALL images (initial and extended)
# database: database from initial reconstruction

# Usage: 
#   PROJECT_PATH=projects/P01-visor/ \
#   FRAMES_LIST=projects/P01-visor/common_P23_05.txt \
#   OUTPUT_NAME=new \
#       sh scripts/colmap_register.sh

NEW_OUTPUT=$PROJECT_PATH/sparse/$OUTPUT_NAME
USE_GPU=1

mkdir $NEW_OUTPUT -p

colmap feature_extractor \
    --database_path $PROJECT_PATH/database.db \
    --image_path / \
    --image_list $FRAMES_LIST \
    --ImageReader.existing_camera_id 1 \
    --ImageReader.single_camera 1 \
    --SiftExtraction.use_gpu $USE_GPU \
    # --ImageReader.mask_path $PROJECT_PATH/masks \

# use larger dictionary
colmap vocab_tree_matcher \
    --database_path $PROJECT_PATH/database.db \
    --VocabTreeMatching.vocab_tree_path vocab_bins/vocab_tree_flickr100K_words256K.bin \
    --SiftMatching.use_gpu $USE_GPU \
# colmap sequential_matcher \
#     --database_path $PROJECT_PATH/database.db
#     --SiftMatching.use_gpu $USE_GPU \

colmap image_registrator \
    --database_path $PROJECT_PATH/database.db \
    --input_path $PROJECT_PATH/sparse/0 \
    --output_path $NEW_OUTPUT

# Or
# colmap mapper \
#     --database_path $PROJECT_PATH/database.db \
#     --image_path $PROJECT_PATH/images \
#     --input_path /path/to/existing-model \
#     --output_path /path/to/model-with-new-images

# colmap bundle_adjuster \
#     --input_path $PROJECT_PATH/new_res \
#     --output_path $PROJECT_PATH/new_res_ba
