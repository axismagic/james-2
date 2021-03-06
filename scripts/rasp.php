#!/usr/bin/php
<?php
ini_set("enable_dl","On");
include('/opt/james/include/wiringpi.php');
include('/opt/james/settings/settings.php');
include('/opt/james/include/func.base.php');
include('/opt/james/include/func.rasp.php');

switch ($GLOBALS['argv'][1]) {
	case "ledTest":
		$leds = $GLOBALS['LEDS'];
		$buttons = $GLOBALS['BUTTONS'];
		asort($leds);
		asort($buttons);

		echo "initializing leds: ";
		foreach ($leds as $i) {
			$oldState = wiringpi::digitalRead($i);
			echo $i . " ";
			blink($i, 2, 50000);
			if ($oldState) switchOn($i);
		}
		echo "done\n";

	break;;

	case "status":
		echo "RaspBerryPi Status Output:\n";
		echo "_LED_\n";
		asort($GLOBALS['LEDS']);
		foreach ($GLOBALS['LEDS'] as $led) {
			if (wiringpi::digitalRead($led) == 1) {
				$str = "on";
			} else {
				$str = "off";
			}
			echo $led . ": " .$str . "\n";
		}

		echo "_Button_\n";
		asort($GLOBALS['BUTTONS']);
		foreach ($GLOBALS['BUTTONS'] as $button) {
			if (wiringpi::digitalRead($button) == 1) {
				$str = "high";
			} else {
				$str = "low";
			}

			echo $button . ": " . $str . "\n";
		}

		echo "_Switch_\n";
		asort($GLOBALS['SWITCHES']);
		foreach ($GLOBALS['SWITCHES'] as $switch) {
			if (wiringpi::digitalRead($switch) == 1) {
				$str = "open";
			} else {
				$str = "closed";
			}

			echo $switch . ": " . $str . "\n";
		}
	break;;

	case "switchOn":
		if ($GLOBALS['argv'][2]) {
			switchOn($GLOBALS['argv'][2]);
			echo "done";
		} else {
			echo "please specify pin";
		}
	break;;

	case "switchOff":
		if ($GLOBALS['argv'][2]) {
			switchOff($GLOBALS['argv'][2]);
			echo "done";
		} else {
			echo "please specify pin";
		}
	break;;

	case "blink":
		if ($GLOBALS['argv'][4]) {
			blink($GLOBALS['argv'][2], $GLOBALS['argv'][3], $GLOBALS['argv'][4]);
			echo "done";
		} else {
			echo "please specify pin amount duration";
		}
	break;;

	default:
		echo "commands: ledTest, status, switchOn, switchOff, blink";
}
?>
