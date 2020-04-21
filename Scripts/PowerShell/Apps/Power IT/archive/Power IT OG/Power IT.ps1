Add-Type -AssemblyName PresentationFramework

Function Get-UserTab($username) {
    $userDT = Get-ADUser -Filter "sAMAccountName -like '*$username*'" -Properties * | Select-Object Name, @{N = 'Username'; E = { $_.sAMAccountName } }, Title, telephoneNumber, @{N = 'Extension'; E = { $_.ipPhone } }, employeeID, mail, @{N = 'Location'; E = { $_.physicalDeliveryOfficeName } }, @{N = 'Current OU'; E = { $_.CanonicalName } }, HomeDirectory
    Return $userDT
}

Function Get-ComputerTab($computername) {
    $computerDT = Get-ADComputer $computername -Properties * | Select-Object Name, @{N = 'Computer OU'; E = { $_.CanonicalName } }, IPv4Address, OperatingSystem, whenCreated
    Return $computerDT
}

Function Get-SearchTab($lastname) {
    $lastnameDT = Get-ADUser -Filter "Name -like '*$lastname*'" -Properties * | Select-Object Name, @{N = 'Username'; E = { $_.sAMAccountName } }, Title, telephoneNumber, @{N = 'Extension'; E = { $_.ipPhone } }, employeeID, mail, @{N = 'Location'; E = { $_.physicalDeliveryOfficeName } }, @{N = 'Current OU'; E = { $_.CanonicalName } }, HomeDirectory
    Return $lastnameDT
}

[xml] $Form = get-content "D:\Powershell\Utilities\Power IT OG\MainWindow.xaml"

$NR = (New-Object System.Xml.XmlNodeReader $Form)
$Win = [Windows.Markup.XamlReader]::Load( $NR )

$username = $win.FindName("boxUsername")
$buttonQueryUser = $win.FindName("buttonUsername")
$userDataGrid = $win.FindName("UserDataGrid")
$buttonClearUser = $win.FindName("buttonUClear")

$computername = $win.FindName("boxComputername")
$buttonQueryComputer = $win.FindName("buttonComputername")
$computerDataGrid = $win.FindName("ComputerDataGrid")
$buttonClearComputer = $win.FindName("buttonCClear")

$lastname = $win.FindName("boxLastname")
$buttonQueryLastname = $win.FindName("buttonLastname")
$lastnameDataGrid = $win.FindName("LastnameDataGrid")
$buttonClearSearch = $win.FindName("buttonSClear")

$arru = New-Object System.Collections.ArrayList
$arrc = New-Object System.Collections.ArrayList
$arrl = New-Object System.Collections.ArrayList


#User Clicks
$buttonQueryUser.add_click( {
        $user = $username.Text
        $userDT = Get-UserTab $user
        $arru.AddRange(@($userDT))
        $userDataGrid.ItemsSource = @($arru)
    })

$buttonClearUser.add_click( {
        $username.Clear()
        $arru.Clear()
        $userDataGrid.ItemsSource = $null
    })

#Computer Clicks
$buttonQueryComputer.add_click( {
        $pc = $computername.Text
        $computerDT = Get-ComputerTab $pc
        $arrc.AddRange(@($computerDT))
        $computerDataGrid.ItemsSource = @($arrc)
    })

$buttonClearComputer.add_click( {
        $computername.Clear()
        $arrc.Clear()
        $computerDataGrid.ItemsSource = $null
    })

#Search Clicks
$buttonQueryLastname.add_click( {
        $search = $lastname.Text
        $lastnameDT = Get-SearchTab $search
        $arrl.AddRange(@($lastnameDT))
        $lastnameDataGrid.ItemsSource = @($arrl)
    })

$buttonClearSearch.add_click( {
        $lastname.Clear()
        $arrl.Clear()
        $lastnameDataGrid.ItemsSource = $null
    })

$Win.ShowDialog()