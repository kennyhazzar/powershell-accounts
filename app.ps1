#  Добавлю все что надо
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Почти ненужная хрень
$global:IfAbout = $false
$global:AboutLabel = $null

# Создание основного окна !@#$%^&*
$Form = New-Object System.Windows.Forms.Form
$Form.Text = 'Select a Computer'
$Form.Size = New-Object System.Drawing.Size(800, 800)
$Form.StartPosition = 'CenterScreen'

# Просто лебел с описанием листбокса
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(350, 20)
$label.Text = 'Локальные учетные записи на этом компьютере:'
$Form.Controls.Add($label)

# Список аккаунтов на компьютере
# $global:listBox = New-Object System.Windows.Forms.ListBox
# $global:listBox.Location = New-Object System.Drawing.Point(10, 50)
# $global:listBox.Size = New-Object System.Drawing.Size(260, 200)
# $global:listBox.Height = 80

# Кнопка просмотра информации о выбранном аккаунте
$CreateAccount = New-Object System.Windows.Forms.Button
$CreateAccount.Location = New-Object System.Drawing.Point(10, 150)
$CreateAccount.Size = New-Object System.Drawing.Size(200, 23)
$CreateAccount.Text = 'Создать...'

# Кнопка для редактирования выбранного пользователя, конкретно имени, потому что менять больше нечего
$EditName = New-Object System.Windows.Forms.Button
$EditName.Location = New-Object System.Drawing.Point(260, 150)
$EditName.Size = New-Object System.Drawing.Size(200, 23)
$EditName.Text = 'Редактировать (имя)'
# Кнопка удаления пользователя
$DeleteAccount = New-Object System.Windows.Forms.Button
$DeleteAccount.Location = New-Object System.Drawing.Point(510, 150)
$DeleteAccount.Size = New-Object System.Drawing.Size(200, 23)
$DeleteAccount.Text = 'Удалить (!)'
function CreateAbout($text) {
    $global:AboutLabel = New-Object System.Windows.Forms.Label
    $global:AboutLabel.Location = New-Object System.Drawing.Point(300, 200)
    $global:AboutLabel.Size = New-Object System.Drawing.Size(200, 1100)
    $global:AboutLabel.Text = $text
    $Form.Controls.Add($AboutLabel)
}

$EditName.Add_Click({
    if ($global:listBox.Text -eq '') {
        addError
    }
    else {
        $EditClickForm = New-Object System.Windows.Forms.Form
        $EditClickForm.Text = 'Редактирование пользователя'
        $EditClickForm.Size = New-Object System.Drawing.Size(500, 150)
        $EditClickForm.StartPosition = 'CenterScreen'

        $EditConfirmLabel = New-Object System.Windows.Forms.Label
        $EditConfirmLabel.Text = 'Пока не работает:('
        $EditConfirmLabel.Location = New-Object System.Drawing.Point(20, 20)
        $EditConfirmLabel.Size = New-Object System.Drawing.Size(500, 23)

        $EditConfirmButton = New-Object System.Windows.Forms.Button
        $EditConfirmButton.Text = "Удалить разработчика:("
        $EditConfirmButton.Location = New-Object System.Drawing.Point(50, 70)
        $EditConfirmButton.Size = New-Object System.Drawing.Size(100, 23)
        $EditConfirmButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

        $EditCancelButton = New-Object System.Windows.Forms.Button
        $EditCancelButton.Text = "Отмена"
        $EditCancelButton.Location = New-Object System.Drawing.Point(200, 70)
        $EditCancelButton.Size = New-Object System.Drawing.Size(100, 23)
        $EditCancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        

        $EditClickForm.Controls.Add($EditConfirmButton)
        $EditClickForm.Controls.Add($EditCancelButton)

        $EditClickForm.AcceptButton = $EditConfirmButton
        $EditClickForm.AcceptButton = $EditCancelButton

        $EditClickForm.Controls.Add($EditConfirmLabel)

        $EditClickForm.ShowDialog()
    }
})

# Добавление в листбокс всех аккаунтов компьютера
function RenderListBox() {
    $Form.Controls.Remove($global:listBox)
    $global:listBox = New-Object System.Windows.Forms.ListBox
    $global:listBox.Location = New-Object System.Drawing.Point(10, 50)
    $global:listBox.Size = New-Object System.Drawing.Size(260, 200)
    $global:listBox.Height = 80
    foreach ($i in Get-LocalUser) {
        [void] $global:listBox.Items.Add($i.Name)
    }
    $Form.Controls.Add($global:listBox)
}

function addError() {
    $global:AboutLabel = New-Object System.Windows.Forms.Label
    $global:AboutLabel.Location = New-Object System.Drawing.Point(300, 200)
    $global:AboutLabel.Size = New-Object System.Drawing.Size(200, 1100)
    $global:AboutLabel.Text = 'Ничего не бы выбрано'
    $Form.Controls.Add($global:AboutLabel)
}

$DeleteAccount.Add_Click( {
        DeleteForm
    })

$CreateAccount.Add_Click( {
        
        $CreateAccountSecondForm = New-Object System.Windows.Forms.Form
        $CreateAccountSecondForm.Text = 'Создание нового пользователя'
        $CreateAccountSecondForm.Size = New-Object System.Drawing.Size(500, 150)
        $CreateAccountSecondForm.StartPosition = 'CenterScreen'

        $CreateNameLabel = New-Object System.Windows.Forms.Label
        $CreateNameLabel.Text = 'Имя'
        $CreateNameLabel.Location = New-Object System.Drawing.Point(20, 20)
        $CreateNameLabel.Size = New-Object System.Drawing.Size(30, 23)

        $CreateNameTextBox = New-Object System.Windows.Forms.TextBox
        $CreateNameTextBox.Location = New-Object System.Drawing.Point(50, 20)
        # $CreateNameTextBox.Add_TextChanged( { $Name = $CreateNameTextBox.Text })

        $CreateConfirmButton = New-Object System.Windows.Forms.Button
        $CreateConfirmButton.Text = "Создать"
        $CreateConfirmButton.Location = New-Object System.Drawing.Point(50, 70)
        $CreateConfirmButton.Size = New-Object System.Drawing.Size(100, 23)
        $CreateConfirmButton.Add_Click( { New-LocalUser -Name $CreateNameTextBox.Text -NoPassword })
        $CreateConfirmButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

        $CreateCancelButton = New-Object System.Windows.Forms.Button
        $CreateCancelButton.Text = "Отмена"
        $CreateCancelButton.Location = New-Object System.Drawing.Point(200, 70)
        $CreateCancelButton.Size = New-Object System.Drawing.Size(100, 23)
        $CreateCancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

        $CreateAccountSecondForm.Controls.Add($CreateConfirmButton)
        $CreateAccountSecondForm.Controls.Add($CreateCancelButton)

        $CreateAccountSecondForm.AcceptButton = $CreateConfirmButton
        $CreateAccountSecondForm.AcceptButton = $CreateCancelButton
        
        $CreateAccountSecondForm.Controls.Add($CreateNameLabel)

        $CreateAccountSecondForm.Controls.Add($CreateNameTextBox)

        $CreateAccountSecondForm.ShowDialog()
        RenderListBox
    })

$Form.Controls.Add($CreateAccount)
$Form.Controls.Add($EditName)
$Form.Controls.Add($DeleteAccount)
RenderListBox
# $Form.Topmost = $true

function DeleteForm {
    if ($global:listBox.Text -eq '') {
        addError
    }
    else {
        $SecondForm = New-Object System.Windows.Forms.Form
        $SecondForm.Text = 'Удалить пользователя ' + $global:listBox.Text + '?'
        $SecondForm.Size = New-Object System.Drawing.Size(500, 150)
        $SecondForm.StartPosition = 'CenterScreen'

        $ConfirmLabel = New-Object System.Windows.Forms.Label
        $ConfirmLabel.Text = 'Вы действительно хотите удалить пользователя ' + $global:listBox.Text + '?'
        $ConfirmLabel.Location = New-Object System.Drawing.Point(20, 20)
        $ConfirmLabel.Size = New-Object System.Drawing.Size(500, 23)

        $ConfirmButton = New-Object System.Windows.Forms.Button
        $ConfirmButton.Text = "Удалить"
        $ConfirmButton.Location = New-Object System.Drawing.Point(50, 70)
        $ConfirmButton.Size = New-Object System.Drawing.Size(100, 23)

        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Text = "Отмена"
        $CancelButton.Location = New-Object System.Drawing.Point(200, 70)
        $CancelButton.Size = New-Object System.Drawing.Size(100, 23)
        $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

        $ConfirmButton.Add_Click( {
                Remove-LocalUser -Name $global:listBox.Text
                $SecondForm.close()
            })

        $SecondForm.CancelButton = $CancelButton

        $SecondForm.Controls.Add($ConfirmButton)
        $SecondForm.Controls.Add($CancelButton)

        $SecondForm.Controls.Add($ConfirmLabel)

        $SecondForm.ShowDialog()
        RenderListBox
    }
}

$Form.ShowDialog()