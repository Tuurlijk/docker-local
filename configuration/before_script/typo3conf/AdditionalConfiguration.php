<?php
defined('TYPO3_MODE') or die('¯\_(ツ)_/¯');

use Symfony\Component\Dotenv\Dotenv;

$dotenv = new Dotenv();
$dotenv->load(__DIR__ . '/../../.env');

$GLOBALS['TYPO3_CONF_VARS']['BE']['lockSSL'] = true;
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['host'] = getenv('TYPO3_DB_HOST');
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['dbname'] = getenv('TYPO3_DB_DATABASE');
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['user'] = getenv('TYPO3_DB_USER');
$GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['password'] = getenv('TYPO3_DB_PASSWORD');

# Custom local dev configuration
$GLOBALS['TYPO3_CONF_VARS']['BE']['debug'] = 1;
//$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['backendFavicon'] = 'EXT:site_michiel/Resources/Public/Icon/develop.ico';
//$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['backendLogo'] = 'EXT:site_michiel/Resources/Public/Icon/develop.svg';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['backend']['loginHighlightColor'] = '#52901b';
$GLOBALS['TYPO3_CONF_VARS']['FE']['debug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'smtp';
$GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_server'] = 'mailhog:1025';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['cookieSecure'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['devIPmask'] = '*';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['fileCreateMask'] = '0664';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['folderCreateMask'] = '0775';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['sitename'] .= ' - local';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern'] = '.*';
