<?php
defined('TYPO3_MODE') or die('¯\_(ツ)_/¯');

use Symfony\Component\Dotenv\Dotenv;

$dotenv = new Dotenv();
$dotenv->load(__DIR__ . '/../../.env');

$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['host'] = 'db';
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['dbname'] = getenv('MYSQL_DATABASE');
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['user'] = getenv('MYSQL_USER');
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['password'] = getenv('MYSQL_PASSWORD');

# Custom local dev configuration
$GLOBALS['TYPO3_CONF_VARS']['BE']['debug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['BE']['lockSSL'] = true;
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['loginHighlightColor'] = '#52901b';
$GLOBALS['TYPO3_CONF_VARS']['FE']['debug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'smtp';
$GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_server'] = 'mail:1025';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['cookieSecure'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['devIPmask'] = '*';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['fileCreateMask'] = '0664';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['folderCreateMask'] = '0775';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['sitename'] .= ' - local';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern'] = '(.*\\.local|.*\\.eu\\.ngrok\\.io)';
//$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['backendFavicon'] = 'EXT:site_michiel/Resources/Public/Icon/develop.ico';
//$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['backendLogo'] = 'EXT:site_michiel/Resources/Public/Icon/develop.svg';
