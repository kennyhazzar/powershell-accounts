Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$global:IfAbout = $false
$global:AboutLabel = $null

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(800, 800)
$form.StartPosition = 'CenterScreen'

# Просто лебел с описанием листбокса
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(100, 20)
$label.Text = 'Локальные учетные записи на этом компьютере:'
$form.Controls.Add($label)

# Список аккаунтов на компьютере
$global:listBox = New-Object System.Windows.Forms.ListBox
$global:listBox.Location = New-Object System.Drawing.Point(10, 50)
$global:listBox.Size = New-Object System.Drawing.Size(260, 200)
$global:listBox.Height = 80

# Кнопка просмотра информации о выбранном аккаунте
$AboutAccount = New-Object System.Windows.Forms.Button
$AboutAccount.Location = New-Object System.Drawing.Point(10, 150)
$AboutAccount.Size = New-Object System.Drawing.Size(200, 23)
$AboutAccount.Text = 'Просмотреть информацию'

function CreateAbout() {
    $global:AboutLabel = New-Object System.Windows.Forms.Label
    $global:AboutLabel.Location = New-Object System.Drawing.Point(10, 200)
    $global:AboutLabel.Size = New-Object System.Drawing.Size(200, 23)
    $global:AboutLabel.Text = $global:listBox.Text
    $global:listBox.Text
    $form.Controls.Add($AboutLabel)
}

$AboutAccount.Add_Click( {
        $form.Controls.Remove($global:AboutLabel)
        $global:AboutLabel = $null
        CreateAbout
    })
$form.Controls.Add($AboutAccount)

# Добавление в листбокс всех аккаунтов компьютера
foreach ($i in Get-CimInstance -ClassName Win32_UserAccount -Property LocalAccount) {
    [void] $global:listBox.Items.Add($i.Name)
}

$form.Controls.Add($global:listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # $c = Get-Credential Domain\Username
    # Restart-Computer -ComputerName "Variable 2 of selection from listbox" -Credential $c -Force
    # $x = $global:listBox.SelectedItem
    # $x
}
