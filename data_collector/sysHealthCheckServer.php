<?php
// router.php
if ($_SERVER["REQUEST_URI"] === '/healthcheck.json') {
    readfile('/tmp/healthcheck.json');
} else {
    http_response_code(404);
    echo "404 Not Found";
}
