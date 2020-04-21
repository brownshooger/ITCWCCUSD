Add-Type -AssemblyName PresentationFramework

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Power IT User &amp; PC Info" Margin="10,10,10,10.3" Height="500" Width="1200">
    <Grid Margin="10">
        <TabControl Margin="10,10,16,14">
            <TabItem Header="User">
                <Grid Background="#FFE5E5E5" Margin="10">
                    <Label Content="Username:" Margin="10,10,0,0" HorizontalAlignment="Left" Width="102" Height="26" VerticalAlignment="Top"/>
                    <TextBox Name="boxUsername" Margin="117,10,0,0" TextWrapping="Wrap" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="173"/>
                    <Button Name="buttonUsername" Content="Query" Margin="295,10,0,0" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="107"/>
                    <Button Name="buttonUClear" Content="Clear" Margin="0,10,10,0" Height="26" VerticalAlignment="Top" HorizontalAlignment="Right" Width="107"/>
                    <DataGrid Name="UserDataGrid" Margin="10,41,10,10"  CanUserSortColumns="True" CanUserResizeColumns="True" CanUserReorderColumns="True"/>
                </Grid>
            </TabItem>
            <TabItem Header="Computer">
                <Grid Background="#FFE5E5E5" Margin="10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="17*"/>
                        <ColumnDefinition Width="415*"/>
                    </Grid.ColumnDefinitions>
                    <Label Content="Computername:" Margin="10,10,0,0" Grid.ColumnSpan="2" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="102"/>
                    <TextBox Name="boxComputername" Margin="101,10,0,0" TextWrapping="Wrap" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="173" Grid.Column="1"/>
                    <Button Name="buttonComputername" Content="Query" Margin="279,10,0,0" Grid.Column="1" HorizontalAlignment="Left" Width="107" Height="26" VerticalAlignment="Top"/>
                    <Button Name="buttonCClear" Content="Clear" Margin="0,10,10,0" Height="26" VerticalAlignment="Top" HorizontalAlignment="Right" Width="107" Grid.Column="1"/>
                    <DataGrid Name="ComputerDataGrid" Margin="10,41,10,10" Grid.ColumnSpan="2"/>
                </Grid>
            </TabItem>
            <TabItem Header="Search">
                <Grid Background="#FFE5E5E5" Margin="10">
                    <Label Content="Lastname:" Margin="10,10,0,0" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="102"/>
                    <TextBox Name="boxLastname" Margin="117,10,0,0" TextWrapping="Wrap" Height="26" VerticalAlignment="Top" HorizontalAlignment="Left" Width="173"/>
                    <Button Name="buttonLastname" Content="Query" Margin="295,10,0,0" HorizontalAlignment="Left" Width="107" Height="26" VerticalAlignment="Top"/>
                    <Button Name="buttonSClear" Content="Clear" Margin="0,10,10,0" Height="26" VerticalAlignment="Top" HorizontalAlignment="Right" Width="107"/>
                    <DataGrid Name="LastnameDataGrid" Margin="10,41,10,10"/>
                </Grid>
            </TabItem>
        </TabControl>

    </Grid>
</Window>


'@


$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Win = [Windows.Markup.XamlReader]::Load( $reader )

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

$Win.ShowDialog() | out-null