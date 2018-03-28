"Hello_World"

Function Get-RegistryValue($key, $value) {

    If ((Test-Path -Path $key) -eq $True) {
    
        (Get-ItemProperty $key $value).$value 
    }

    else {
    
        #wirte-log
        exit
    
    }

} 

Function Get-UACLevel() {

	$ConsentPromptBehaviorAdmin_Value = Get-RegistryValue $Key $ConsentPromptBehaviorAdmin_Name

	$PromptOnSecureDesktop_Value = Get-RegistryValue $Key $PromptOnSecureDesktop_Name

	If($ConsentPromptBehaviorAdmin_Value -Eq 0 -And $PromptOnSecureDesktop_Value -Eq 0) {
        
        #"Never notIfy"
        $UACLevel = 0 

	}

	ElseIf($ConsentPromptBehaviorAdmin_Value -Eq 5 -And $PromptOnSecureDesktop_Value -Eq 0) {

		#"NotIfy me only(do not dim my desktop)"
        $UACLevel = 1 

	}

	ElseIf($ConsentPromptBehaviorAdmin_Value -Eq 5 -And $PromptOnSecureDesktop_Value -Eq 1) {

		#"NotIfy me only(default)"
        $UACLevel = 2 
	}

	ElseIf($ConsentPromptBehaviorAdmin_Value -Eq 2 -And $PromptOnSecureDesktop_Value -Eq 1) {

		#"Always notIfy"
        $UACLevel = 3 
	}

	Else {

        #wirte-log
        exit

	}

}

Function Set-RegistryValue($key,$value,$name) {

    If ((Test-Path -Path $key) -eq $True) {
    
        Set-ItemProperty -Path $key -Name $name -Value $value -Type $type
    }

    else {
    
        #wirte-log
        exit
    
    }

} 

Function Set-UACLevel($UACLevelInput) {

	New-Variable -Name PromptOnSecureDesktop_Value

	New-Variable -Name ConsentPromptBehaviorAdmin_Value

	    Switch ($UACLevelInput) {

        0 {

            $ConsentPromptBehaviorAdmin_Value = 0

            $PromptOnSecureDesktop_Value = 0

		  } 

        1 {
            $ConsentPromptBehaviorAdmin_Value = 5 

            $PromptOnSecureDesktop_Value = 0
		  } 

        2 {
            $ConsentPromptBehaviorAdmin_Value = 5 

            $PromptOnSecureDesktop_Value = 1
		  } 

        3 {
            $ConsentPromptBehaviorAdmin_Value = 2 

            $PromptOnSecureDesktop_Value = 1
		  } 

        default {
        
            "not support"
            exit
        
        }

        }

        Set-RegistryValue -Key $Key -Name $ConsentPromptBehaviorAdmin_Name -Value $ConsentPromptBehaviorAdmin_Value

        Set-RegistryValue -Key $Key -Name $PromptOnSecureDesktop_Name -Value $PromptOnSecureDesktop_Value

		Get-UACLevel

	
}



$type="Dword"

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'

$ConsentPromptBehaviorAdmin_Name = 'ConsentPromptBehaviorAdmin'

$PromptOnSecureDesktop_Name = 'PromptOnSecureDesktop'

Get-UACLevel

$UACLevelBAK = $UACLevel

Set-UACLevel -UACLevelInput 0

$UACLevelBAK 
