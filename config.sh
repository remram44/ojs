# <?php exit(): ?>
cat config.TEMPLATE.inc.php | \
    sed 's#^base_url = .*$#base_url = "'"$SETTING_BASE_URL"'"#' \
    >config.inc.php
