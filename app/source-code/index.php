<?php
$directory = '/s3-mount';

if (is_dir($directory)) {
    if ($handle = opendir($directory)) {
        while (false !== ($entry = readdir($handle))) {
            if ($entry != "." && $entry != "..") {
                echo "$entry\n";
            }
        }
        closedir($handle);
    }
}

echo phpinfo();


