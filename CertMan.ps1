# Ensure required assemblies are loaded
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Certificate Store Manager" Height="750" Width="1100"
        WindowStartupLocation="CenterScreen" Background="#1E1E24" SnapsToDevicePixels="True">
    
    <Window.Resources>
        <!-- Modern ScrollViewer style -->
        <Style TargetType="ScrollBar">
            <Setter Property="Background" Value="#1E1E24"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Style.Triggers>
                <Trigger Property="Orientation" Value="Vertical">
                    <Setter Property="Width" Value="8"/>
                    <Setter Property="Height" Value="Auto"/>
                </Trigger>
                <Trigger Property="Orientation" Value="Horizontal">
                    <Setter Property="Height" Value="8"/>
                    <Setter Property="Width" Value="Auto"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern ProgressBar Template -->
        <Style TargetType="ProgressBar">
            <Setter Property="Background" Value="#333340"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="8"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ProgressBar">
                        <Grid x:Name="TemplateRoot">
                            <Border Background="{TemplateBinding Background}" CornerRadius="4"/>
                            <Border x:Name="PART_Indicator" Background="{TemplateBinding Foreground}" CornerRadius="4" HorizontalAlignment="Left"/>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Modern Button Style -->
        <Style x:Key="SidebarButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#B0B0C0"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="15,12"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2A2A35"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Background" Value="#007ACC"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="4" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#0098FF"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Background" Value="#444455"/>
                    <Setter Property="Foreground" Value="#888899"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="DangerButton" TargetType="Button" BasedOn="{StaticResource ActionButton}">
            <Setter Property="Background" Value="#D9534F"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#C9302C"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern DataGrid Header -->
        <Style TargetType="DataGridColumnHeader">
            <Setter Property="Background" Value="#2A2A35"/>
            <Setter Property="Foreground" Value="#B0B0C0"/>
            <Setter Property="Padding" Value="10,8"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="BorderThickness" Value="0,0,0,1"/>
            <Setter Property="BorderBrush" Value="#3F3F52"/>
        </Style>

        <!-- Modern DataGrid Row -->
        <Style TargetType="DataGridRow">
            <Setter Property="Background" Value="#202028"/>
            <Setter Property="Foreground" Value="#F0F0F0"/>
            <Setter Property="BorderThickness" Value="0,0,0,1"/>
            <Setter Property="BorderBrush" Value="#2A2A35"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2A2A35"/>
                </Trigger>
                <Trigger Property="IsSelected" Value="True">
                    <Setter Property="Background" Value="#334E68"/>
                    <Setter Property="Foreground" Value="White"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern TreeView -->
        <Style TargetType="TreeViewItem">
            <Setter Property="Foreground" Value="#B0B0C0"/>
            <Style.Resources>
                <SolidColorBrush x:Key="{x:Static SystemColors.HighlightBrushKey}" Color="#334E68"/>
                <SolidColorBrush x:Key="{x:Static SystemColors.InactiveSelectionHighlightBrushKey}" Color="#2A2A35"/>
                <SolidColorBrush x:Key="{x:Static SystemColors.HighlightTextBrushKey}" Color="#FFFFFF"/>
            </Style.Resources>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="220"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- Left Sidebar Navigation -->
        <Border Grid.Column="0" Background="#16161A" BorderBrush="#2A2A35" BorderThickness="0,0,1,0">
            <Grid Margin="10,20,10,20">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="20"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <!-- App Title/Logo -->
                <StackPanel Grid.Row="0" Orientation="Horizontal" HorizontalAlignment="Center">
                    <TextBlock Text="&#xE72E;" FontFamily="Segoe MDL2 Assets" FontSize="20" Foreground="#007ACC" Margin="0,0,10,0" VerticalAlignment="Center"/>
                    <TextBlock Text="CertMan" FontSize="20" FontWeight="Bold" Foreground="#FFFFFF" VerticalAlignment="Center"/>
                </StackPanel>

                <!-- Navigation Buttons -->
                <Button x:Name="BtnDashboard" Grid.Row="2" Style="{StaticResource SidebarButton}">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="&#xE9D2;" FontFamily="Segoe MDL2 Assets" FontSize="14" Margin="0,0,10,0" VerticalAlignment="Center"/>
                        <TextBlock Text="Dashboard" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>

                <Button x:Name="BtnExplorer" Grid.Row="4" Style="{StaticResource SidebarButton}">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="&#xE8B7;" FontFamily="Segoe MDL2 Assets" FontSize="14" Margin="0,0,10,0" VerticalAlignment="Center"/>
                        <TextBlock Text="Store Explorer" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>

                <!-- App Version / User Info at bottom -->
                <StackPanel Grid.Row="6" Margin="10,0">
                    <TextBlock Text="Status: Connected" FontSize="11" Foreground="#5CB85C" Margin="0,0,0,5"/>
                    <TextBlock Text="v1.0.0" FontSize="10" Foreground="#666677"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- Main Content Area -->
        <Grid Grid.Column="1" Margin="25">
            <!-- Dashboard View -->
            <Grid x:Name="PanelDashboard" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="130"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>

                <!-- Header -->
                <StackPanel Grid.Row="0" Margin="0,0,0,20">
                    <TextBlock Text="Dashboard" FontSize="26" FontWeight="Bold" Foreground="#FFFFFF"/>
                    <TextBlock Text="Overview of system certificate health and expirations (Click cards to filter in explorer)" FontSize="13" Foreground="#B0B0C0" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Summary Cards -->
                <UniformGrid Grid.Row="1" Columns="4" Margin="0,0,0,20">
                    <!-- Total -->
                    <Border x:Name="CardTotal" Background="#2A2A35" CornerRadius="8" Margin="0,0,10,0" Padding="15" Cursor="Hand" ToolTip="Click to view all certificates">
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock Text="TOTAL CERTIFICATES" FontSize="11" FontWeight="Bold" Foreground="#888899"/>
                            <TextBlock x:Name="TxtTotalCount" Text="0" FontSize="28" FontWeight="Bold" Foreground="#FFFFFF" Margin="0,8,0,0"/>
                        </StackPanel>
                    </Border>
                    <!-- Healthy -->
                    <Border x:Name="CardHealthy" Background="#2A2A35" CornerRadius="8" Margin="5,0,5,0" Padding="15" BorderBrush="#5CB85C" BorderThickness="0,0,0,3" Cursor="Hand" ToolTip="Click to view healthy certificates">
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock Text="HEALTHY (>30 Days)" FontSize="11" FontWeight="Bold" Foreground="#888899"/>
                            <TextBlock x:Name="TxtHealthyCount" Text="0" FontSize="28" FontWeight="Bold" Foreground="#5CB85C" Margin="0,8,0,0"/>
                        </StackPanel>
                    </Border>
                    <!-- Expiring Soon -->
                    <Border x:Name="CardSoon" Background="#2A2A35" CornerRadius="8" Margin="5,0,5,0" Padding="15" BorderBrush="#F0AD4E" BorderThickness="0,0,0,3" Cursor="Hand" ToolTip="Click to view certificates expiring soon">
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock Text="EXPIRING SOON" FontSize="11" FontWeight="Bold" Foreground="#888899"/>
                            <TextBlock x:Name="TxtSoonCount" Text="0" FontSize="28" FontWeight="Bold" Foreground="#F0AD4E" Margin="0,8,0,0"/>
                        </StackPanel>
                    </Border>
                    <!-- Expired -->
                    <Border x:Name="CardExpired" Background="#2A2A35" CornerRadius="8" Margin="10,0,0,0" Padding="15" BorderBrush="#D9534F" BorderThickness="0,0,0,3" Cursor="Hand" ToolTip="Click to view expired certificates">
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock Text="EXPIRED" FontSize="11" FontWeight="Bold" Foreground="#888899"/>
                            <TextBlock x:Name="TxtExpiredCount" Text="0" FontSize="28" FontWeight="Bold" Foreground="#D9534F" Margin="0,8,0,0"/>
                        </StackPanel>
                    </Border>
                </UniformGrid>

                <!-- Detailed sections -->
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- Top 5 Expiring Certificates List -->
                    <Border Background="#2A2A35" CornerRadius="8" Padding="20">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="15"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            
                            <TextBlock Grid.Row="0" Text="Top 5 Certificates Closest to Expiring" FontSize="16" FontWeight="Bold" Foreground="#FFFFFF"/>
                            
                            <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                                <StackPanel x:Name="PanelTopExpiring">
                                    <!-- Dynamic rows loaded from PowerShell -->
                                </StackPanel>
                            </ScrollViewer>
                        </Grid>
                    </Border>
                </Grid>
            </Grid>

            <!-- Store Explorer View -->
            <Grid x:Name="PanelExplorer" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <!-- Header & Search -->
                <Grid Grid.Row="0" Margin="0,0,0,15">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="280"/>
                    </Grid.ColumnDefinitions>
                    
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="Certificate Store Explorer" FontSize="26" FontWeight="Bold" Foreground="#FFFFFF"/>
                        <TextBlock Text="Browse, export, delete or import certificates into local stores" FontSize="13" Foreground="#B0B0C0" Margin="0,5,0,0"/>
                    </StackPanel>

                    <StackPanel Grid.Column="1" VerticalAlignment="Bottom">
                        <TextBlock Text="Search / Status Filter" FontSize="11" Foreground="#B0B0C0" Margin="0,0,0,4"/>
                        <TextBox x:Name="TxtSearch" Height="28" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" BorderThickness="1" Padding="5,3" VerticalContentAlignment="Center"/>
                    </StackPanel>
                </Grid>

                <!-- Main Split Pane -->
                <Grid Grid.Row="1">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="280"/>
                        <ColumnDefinition Width="15"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- TreeView on Left -->
                    <Border Grid.Column="0" Background="#2A2A35" CornerRadius="8" Padding="10">
                        <TreeView x:Name="TreeStores" Background="Transparent" BorderThickness="0">
                            <!-- Populated dynamically -->
                        </TreeView>
                    </Border>

                    <!-- Certificates Grid on Right -->
                    <Border Grid.Column="2" Background="#2A2A35" CornerRadius="8" Padding="15">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>

                            <TextBlock x:Name="TxtSelectedStoreName" Text="Select a store from the tree view" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                            
                            <DataGrid x:Name="GridCerts" Grid.Row="2" AutoGenerateColumns="False" CanUserAddRows="False" 
                                      HeadersVisibility="Column" SelectionMode="Single"
                                      Background="Transparent" BorderThickness="0" GridLinesVisibility="None" IsReadOnly="True">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Subject" Binding="{Binding Subject}" Width="*"/>
                                    <DataGridTextColumn Header="Issuer" Binding="{Binding Issuer}" Width="*"/>
                                    <DataGridTextColumn Header="Expiration Date" Binding="{Binding ExpiryDate}" Width="150"/>
                                    <DataGridTextColumn Header="Status" Binding="{Binding Status}" Width="100"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </Border>
                </Grid>

                <!-- Actions Row -->
                <Border Grid.Row="2" Background="#2A2A35" CornerRadius="8" Margin="0,15,0,0" Padding="15">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>

                        <StackPanel Grid.Column="0" Orientation="Horizontal">
                            <Button x:Name="BtnViewDetails" Style="{StaticResource ActionButton}" Margin="0,0,10,0" IsEnabled="False">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="&#xE71E;" FontFamily="Segoe MDL2 Assets" FontSize="12" Margin="0,0,8,0" VerticalAlignment="Center"/>
                                    <TextBlock Text="View Details" VerticalAlignment="Center"/>
                                </StackPanel>
                            </Button>
                            <Button x:Name="BtnExport" Style="{StaticResource ActionButton}" Margin="0,0,10,0" IsEnabled="False">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="&#xE72D;" FontFamily="Segoe MDL2 Assets" FontSize="12" Margin="0,0,8,0" VerticalAlignment="Center"/>
                                    <TextBlock Text="Export" VerticalAlignment="Center"/>
                                </StackPanel>
                            </Button>
                            <Button x:Name="BtnDelete" Style="{StaticResource DangerButton}" IsEnabled="False">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="&#xE74D;" FontFamily="Segoe MDL2 Assets" FontSize="12" Margin="0,0,8,0" VerticalAlignment="Center"/>
                                    <TextBlock Text="Delete" VerticalAlignment="Center"/>
                                </StackPanel>
                            </Button>
                        </StackPanel>

                        <StackPanel Grid.Column="2">
                            <Button x:Name="BtnImport" Style="{StaticResource ActionButton}">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="&#xE896;" FontFamily="Segoe MDL2 Assets" FontSize="12" Margin="0,0,8,0" VerticalAlignment="Center"/>
                                    <TextBlock Text="Import Certificate..." VerticalAlignment="Center"/>
                                </StackPanel>
                            </Button>
                        </StackPanel>
                    </Grid>
                </Border>
            </Grid>
        </Grid>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get UI Control References
$btnDashboard = $window.FindName("BtnDashboard")
$btnExplorer = $window.FindName("BtnExplorer")
$panelDashboard = $window.FindName("PanelDashboard")
$panelExplorer = $window.FindName("PanelExplorer")

# Dashboard cards
$cardTotal = $window.FindName("CardTotal")
$cardHealthy = $window.FindName("CardHealthy")
$cardSoon = $window.FindName("CardSoon")
$cardExpired = $window.FindName("CardExpired")

$txtTotalCount = $window.FindName("TxtTotalCount")
$txtHealthyCount = $window.FindName("TxtHealthyCount")
$txtSoonCount = $window.FindName("TxtSoonCount")
$txtExpiredCount = $window.FindName("TxtExpiredCount")
$panelTopExpiring = $window.FindName("PanelTopExpiring")

$txtSearch = $window.FindName("TxtSearch")
$treeStores = $window.FindName("TreeStores")
$gridCerts = $window.FindName("GridCerts")
$txtSelectedStoreName = $window.FindName("TxtSelectedStoreName")

$btnViewDetails = $window.FindName("BtnViewDetails")
$btnExport = $window.FindName("BtnExport")
$btnDelete = $window.FindName("BtnDelete")
$btnImport = $window.FindName("BtnImport")

# Track selected certificate and store path
$script:selectedCert = $null
$script:selectedStorePath = $null

# Helper: Show custom MessageBox dialog for premium styling
function Show-Dialog {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Type = "Info" # Info, Error, Warning, Confirm
    )
    
    [xml]$dialogXaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            Title="$Title" Height="200" Width="400"
            WindowStartupLocation="CenterOwner" Background="#1E1E24" SnapsToDevicePixels="True" ResizeMode="NoResize">
        <Grid Margin="20">
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            
            <TextBlock Text="$Message" Foreground="#F0F0F0" FontSize="14" TextWrapping="Wrap" VerticalAlignment="Center" HorizontalAlignment="Center" TextAlignment="Center"/>
            
            <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,15,0,0">
                <Button x:Name="BtnOk" Content="OK" Width="80" Height="30" Margin="5" Background="#007ACC" Foreground="White" BorderThickness="0"/>
                <Button x:Name="BtnCancel" Content="Cancel" Width="80" Height="30" Margin="5" Background="#444455" Foreground="White" BorderThickness="0" Visibility="Collapsed"/>
            </StackPanel>
        </Grid>
    </Window>
"@
    $dlgReader = New-Object System.Xml.XmlNodeReader $dialogXaml
    $dlg = [Windows.Markup.XamlReader]::Load($dlgReader)
    $dlg.Owner = $window
    
    $btnOk = $dlg.FindName("BtnOk")
    $btnCancel = $dlg.FindName("BtnCancel")
    
    if ($Type -eq "Confirm") {
        $btnCancel.Visibility = [System.Windows.Visibility]::Visible
    }
    
    $result = $false
    $btnOk.Add_Click({
        $script:dialogResult = $true
        $dlg.Close()
    })
    $btnCancel.Add_Click({
        $script:dialogResult = $false
        $dlg.Close()
    })
    
    $dlg.ShowDialog() | Out-Null
    return $script:dialogResult
}

# Load All Certificates data
function Get-AllCertificates {
    $certs = @()
    # Query CurrentUser and LocalMachine stores
    $locations = @("CurrentUser", "LocalMachine")
    foreach ($loc in $locations) {
        if (Test-Path "Cert:\$loc") {
            Get-ChildItem -Path "Cert:\$loc" -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
                $storeName = $_.Name
                $storePath = "Cert:\$loc\$storeName"
                Get-ChildItem -Path $storePath -ErrorAction SilentlyContinue | ForEach-Object {
                    $cert = $_
                    # Calculate percentage lifetime remaining
                    $totalLifetime = ($cert.NotAfter - $cert.NotBefore).TotalDays
                    $remainingDays = ($cert.NotAfter - (Get-Date)).TotalDays
                    
                    $percent = 0
                    if ($totalLifetime -gt 0) {
                        $percent = ($remainingDays / $totalLifetime) * 100
                        if ($percent -lt 0) { $percent = 0 }
                        if ($percent -gt 100) { $percent = 100 }
                    }
                    
                    # Status label
                    $status = "Healthy"
                    $statusBrush = "#5CB85C" # Green
                    if ($remainingDays -le 0) {
                        $status = "Expired"
                        $statusBrush = "#D9534F" # Red
                    } elseif ($remainingDays -le 30) {
                        $status = "Expiring Soon"
                        $statusBrush = "#F0AD4E" # Orange
                    }
                    
                    $certs += [PSCustomObject]@{
                        Thumbprint  = $cert.Thumbprint
                        Subject     = $cert.Subject
                        Issuer      = $cert.Issuer
                        ExpiryDate  = $cert.NotAfter
                        FriendlyName= $cert.FriendlyName
                        StorePath   = $storePath
                        Remaining   = [Math]::Round($remainingDays, 1)
                        Percent     = [Math]::Round($percent, 1)
                        Status      = $status
                        StatusBrush = $statusBrush
                        RawCert     = $cert
                    }
                }
            }
        }
    }
    return $certs
}

# Update Dashboard visualisations
function Update-Dashboard {
    $certs = Get-AllCertificates
    
    # Counts
    $total = $certs.Count
    $healthy = ($certs | Where-Object { $_.Status -eq "Healthy" }).Count
    $soon = ($certs | Where-Object { $_.Status -eq "Expiring Soon" }).Count
    $expired = ($certs | Where-Object { $_.Status -eq "Expired" }).Count
    
    $txtTotalCount.Text = $total.ToString()
    $txtHealthyCount.Text = $healthy.ToString()
    $txtSoonCount.Text = $soon.ToString()
    $txtExpiredCount.Text = $expired.ToString()
    
    # Refresh top 5 closest to expiring
    $panelTopExpiring.Children.Clear()
    
    # Sort by remaining days (including expired ones first, but maybe we want expiring ones that are close)
    $top5 = $certs | Sort-Object Remaining | Select-Object -First 5
    
    foreach ($c in $top5) {
        # Create row UI
        [xml]$rowXaml = @"
        <Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                Background="#333340" CornerRadius="6" Margin="0,0,0,10" Padding="15" Cursor="Hand" ToolTip="Click to view details">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Row="0" Grid.Column="0">
                    <TextBlock Text="$($c.Subject)" FontWeight="Bold" Foreground="#FFFFFF" FontSize="14" TextTrimming="CharacterEllipsis"/>
                    <TextBlock Text="Store: $($c.StorePath) | Expiry: $($c.ExpiryDate.ToString('yyyy-MM-dd'))" Foreground="#B0B0C0" FontSize="11" Margin="0,3,0,0"/>
                </StackPanel>

                <TextBlock Grid.Row="0" Grid.Column="1" Text="$($c.Remaining) Days Left" FontWeight="Bold" Foreground="$($c.StatusBrush)" VerticalAlignment="Center" FontSize="13"/>

                <ProgressBar Grid.Row="2" Grid.ColumnSpan="2" Minimum="0" Maximum="100" Value="$($c.Percent)" Foreground="$($c.StatusBrush)"/>
            </Grid>
        </Border>
"@
        $rowReader = New-Object System.Xml.XmlNodeReader $rowXaml
        $rowElement = [Windows.Markup.XamlReader]::Load($rowReader)
        
        # Store the cert object in the Tag property of the element to avoid closure/scoping issues
        $rowElement.Tag = $c
        $rowElement.Add_MouseLeftButtonDown({
            Show-CertDetails $this.Tag
        })
        
        $panelTopExpiring.Children.Add($rowElement) | Out-Null
    }
}

# Populate Certificate Stores Tree
function Populate-StoreTree {
    $treeStores.Items.Clear()
    
    # Global/All Stores root node
    $allStoresNode = New-Object System.Windows.Controls.TreeViewItem
    $allStoresNode.Header = "All Stores (Global View)"
    $allStoresNode.Tag = "Global"
    $allStoresNode.IsExpanded = $true
    $treeStores.Items.Add($allStoresNode) | Out-Null
    
    $locations = @("CurrentUser", "LocalMachine")
    
    foreach ($loc in $locations) {
        $rootNode = New-Object System.Windows.Controls.TreeViewItem
        $rootNode.Header = $loc
        $rootNode.Tag = "Cert:\$loc"
        $rootNode.IsExpanded = $true
        
        if (Test-Path "Cert:\$loc") {
            Get-ChildItem -Path "Cert:\$loc" | Where-Object { $_.PSIsContainer } | ForEach-Object {
                $subNode = New-Object System.Windows.Controls.TreeViewItem
                $subNode.Header = $_.Name
                $subNode.Tag = "Cert:\$loc\$($_.Name)"
                $rootNode.Items.Add($subNode) | Out-Null
            }
        }
        # Add under the main tree root
        $treeStores.Items.Add($rootNode) | Out-Null
    }
}

# Load Certificates for selected store
function Load-StoreCertificates {
    param([string]$storePath)
    
    $script:selectedStorePath = $storePath
    
    if (-not $storePath) {
        $txtSelectedStoreName.Text = "Select a store from the tree view"
        $gridCerts.ItemsSource = $null
        return
    }
    
    $allCerts = Get-AllCertificates
    
    if ($storePath -eq "Global") {
        $txtSelectedStoreName.Text = "All Stores (Global View)"
        $filtered = $allCerts
    } else {
        $txtSelectedStoreName.Text = $storePath
        $filtered = $allCerts | Where-Object { $_.StorePath -eq $storePath }
    }
    
    # Apply text filter if any
    $filterText = $txtSearch.Text.Trim()
    if ($filterText) {
        $filtered = $filtered | Where-Object { 
            $_.Subject -like "*$filterText*" -or 
            $_.Issuer -like "*$filterText*" -or 
            $_.Thumbprint -like "*$filterText*" -or
            $_.Status -like "*$filterText*"
        }
    }
    
    $gridCerts.ItemsSource = $filtered
}

# Helper to navigate to explorer and set a search filter
function Navigate-To-Explorer-With-Filter {
    param(
        [string]$filterText
    )
    
    # Switch Views
    $panelDashboard.Visibility = [System.Windows.Visibility]::Collapsed
    $panelExplorer.Visibility = [System.Windows.Visibility]::Visible
    
    # Populate stores tree
    Populate-StoreTree
    
    # Select the "Global" node
    $globalNode = $treeStores.Items[0]
    if ($globalNode) {
        $globalNode.IsSelected = $true
    }
    
    # Set search filter text
    $txtSearch.Text = $filterText
    
    # Load certificates for "Global" store with this filter
    Load-StoreCertificates "Global"
}

# Event: Click on Dashboard Cards to filter
$cardTotal.Add_MouseLeftButtonDown({
    Navigate-To-Explorer-With-Filter ""
})

$cardHealthy.Add_MouseLeftButtonDown({
    Navigate-To-Explorer-With-Filter "Healthy"
})

$cardSoon.Add_MouseLeftButtonDown({
    Navigate-To-Explorer-With-Filter "Expiring Soon"
})

$cardExpired.Add_MouseLeftButtonDown({
    Navigate-To-Explorer-With-Filter "Expired"
})

# Event: Switch Panels
$btnDashboard.Add_Click({
    $panelDashboard.Visibility = [System.Windows.Visibility]::Visible
    $panelExplorer.Visibility = [System.Windows.Visibility]::Collapsed
    Update-Dashboard
})

$btnExplorer.Add_Click({
    $panelDashboard.Visibility = [System.Windows.Visibility]::Collapsed
    $panelExplorer.Visibility = [System.Windows.Visibility]::Visible
    Populate-StoreTree
    Load-StoreCertificates $script:selectedStorePath
})

# Event: Tree Store Selected
$treeStores.Add_SelectedItemChanged({
    $selectedItem = $treeStores.SelectedItem
    if ($selectedItem -and $selectedItem.Tag) {
        Load-StoreCertificates $selectedItem.Tag
    } else {
        Load-StoreCertificates $null
    }
})

# Event: Search box changed
$txtSearch.Add_TextChanged({
    Load-StoreCertificates $script:selectedStorePath
})

# Event: Grid Selection Changed
$gridCerts.Add_SelectionChanged({
    $selected = $gridCerts.SelectedItem
    if ($selected) {
        $script:selectedCert = $selected
        $btnViewDetails.IsEnabled = $true
        $btnExport.IsEnabled = $true
        # Deleting from the global view requires care, ensure we know the store path
        $btnDelete.IsEnabled = ($selected.StorePath -ne $null)
    } else {
        $script:selectedCert = $null
        $btnViewDetails.IsEnabled = $false
        $btnExport.IsEnabled = $false
        $btnDelete.IsEnabled = $false
    }
})

# Details Modal
function Show-CertDetails {
    param($certObj)
    
    if (-not $certObj) { return }
    $cert = $certObj.RawCert
    if (-not $cert) { return }
    
    [xml]$detailXaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            Title="Certificate Details" Height="500" Width="600"
            WindowStartupLocation="CenterOwner" Background="#1E1E24" SnapsToDevicePixels="True">
        <Grid Margin="20">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="15"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            
            <TextBlock Text="Certificate Properties" FontSize="20" FontWeight="Bold" Foreground="#FFFFFF"/>
            
            <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                <StackPanel>
                    <TextBlock Text="Subject" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.Subject)" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" TextWrapping="Wrap" Padding="5"/>

                    <TextBlock Text="Issuer" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.Issuer)" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" TextWrapping="Wrap" Padding="5"/>

                    <TextBlock Text="Thumbprint" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.Thumbprint)" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" Padding="5"/>

                    <TextBlock Text="Valid From" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.NotBefore.ToString('yyyy-MM-dd HH:mm:ss'))" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" Padding="5"/>

                    <TextBlock Text="Valid To (Expiration)" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.NotAfter.ToString('yyyy-MM-dd HH:mm:ss'))" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" Padding="5"/>

                    <TextBlock Text="Signature Algorithm" FontSize="11" Foreground="#888899" Margin="0,10,0,2"/>
                    <TextBox Text="$($cert.SignatureAlgorithm.FriendlyName)" IsReadOnly="True" Background="#2A2A35" Foreground="#FFFFFF" BorderBrush="#3F3F52" Padding="5"/>
                </StackPanel>
            </ScrollViewer>
            
            <Button x:Name="BtnClose" Grid.Row="3" Content="Close" Width="100" Height="30" Margin="0,15,0,0" HorizontalAlignment="Right" Background="#007ACC" Foreground="White" BorderThickness="0"/>
        </Grid>
    </Window>
"@
    $dlgReader = New-Object System.Xml.XmlNodeReader $detailXaml
    $dlg = [Windows.Markup.XamlReader]::Load($dlgReader)
    $dlg.Owner = $window
    
    $btnClose = $dlg.FindName("BtnClose")
    $btnClose.Add_Click({ $dlg.Close() })
    
    $dlg.ShowDialog() | Out-Null
}

$btnViewDetails.Add_Click({
    if ($script:selectedCert) {
        Show-CertDetails $script:selectedCert
    }
})

# Double click grid item to view details
$gridCerts.Add_MouseDoubleClick({
    $selected = $gridCerts.SelectedItem
    if ($selected) {
        Show-CertDetails $selected
    }
})

# Export Certificate
$btnExport.Add_Click({
    if ($script:selectedCert) {
        $sfd = New-Object Microsoft.Win32.SaveFileDialog
        $sfd.Filter = "CER Certificate (*.cer)|*.cer|DER Certificate (*.der)|*.der"
        $sfd.Title = "Export Certificate"
        $sfd.FileName = ($script:selectedCert.RawCert.Subject -split "CN=")[-1] -replace '[\\\/:*?"<>|]', ''
        
        if ($sfd.ShowDialog($window) -eq $true) {
            try {
                $bytes = $script:selectedCert.RawCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
                [System.IO.File]::WriteAllBytes($sfd.FileName, $bytes)
                Show-Dialog -Title "Export Successful" -Message "Certificate exported successfully to $($sfd.FileName)" -Type "Info"
            } catch {
                Show-Dialog -Title "Export Failed" -Message "Failed to export certificate: $($_.Exception.Message)" -Type "Error"
            }
        }
    }
})

# Import Certificate
$btnImport.Add_Click({
    # Require selecting a specific physical store to import, not Global
    if (-not $script:selectedStorePath -or $script:selectedStorePath -eq "Global") {
        Show-Dialog -Title "No Store Selected" -Message "Please select a specific store folder from the tree view on the left (e.g. CurrentUser\My) before importing." -Type "Warning"
        return
    }
    
    $ofd = New-Object Microsoft.Win32.OpenFileDialog
    $ofd.Filter = "Certificate Files (*.cer, *.pfx, *.p12)|*.cer;*.pfx;*.p12|All Files (*.*)|*.*"
    $ofd.Title = "Select Certificate to Import"
    
    if ($ofd.ShowDialog($window) -eq $true) {
        try {
            # Check if it requires a password (e.g. pfx)
            $isPfx = $ofd.FileName.EndsWith(".pfx") -or $ofd.FileName.EndsWith(".p12")
            $password = $null
            
            if ($isPfx) {
                # Simple custom prompt for password
                [xml]$pwXaml = @"
                <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                        Title="Enter Password" Height="180" Width="350"
                        WindowStartupLocation="CenterOwner" Background="#1E1E24" ResizeMode="NoResize">
                    <Grid Margin="20">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <TextBlock Text="Password for PFX file:" Foreground="White" Margin="0,0,0,5"/>
                        <PasswordBox x:Name="TxtPassword" Grid.Row="1" Height="28" Background="#2A2A35" Foreground="White" BorderBrush="#3F3F52"/>
                        <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,15,0,0">
                            <Button x:Name="BtnOk" Content="OK" Width="70" Height="28" Margin="5" Background="#007ACC" Foreground="White" BorderThickness="0"/>
                        </StackPanel>
                    </Grid>
                </Window>
"@
                $pwReader = New-Object System.Xml.XmlNodeReader $pwXaml
                $pwDlg = [Windows.Markup.XamlReader]::Load($pwReader)
                $pwDlg.Owner = $window
                $txtPassword = $pwDlg.FindName("TxtPassword")
                $pwBtnOk = $pwDlg.FindName("BtnOk")
                
                $pwBtnOk.Add_Click({ $pwDlg.Close() })
                $pwDlg.ShowDialog() | Out-Null
                $password = $txtPassword.Password
            }
            
            $store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList ($script:selectedStorePath)
            # Open store with write access
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            
            $certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
            if ($isPfx) {
                $certCollection.Import($ofd.FileName, $password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet)
            } else {
                $certCollection.Import($ofd.FileName)
            }
            
            foreach ($cert in $certCollection) {
                $store.Add($cert)
            }
            
            $store.Close()
            Show-Dialog -Title "Import Successful" -Message "Certificate(s) imported successfully into $script:selectedStorePath" -Type "Info"
            Load-StoreCertificates $script:selectedStorePath
        } catch {
            Show-Dialog -Title "Import Failed" -Message "Failed to import certificate: $($_.Exception.Message)" -Type "Error"
        }
    }
})

# Delete Certificate
$btnDelete.Add_Click({
    if ($script:selectedCert) {
        $confirm = Show-Dialog -Title "Confirm Deletion" -Message "Are you sure you want to delete the certificate for '$($script:selectedCert.Subject)'? This action cannot be undone." -Type "Confirm"
        if ($confirm) {
            try {
                $store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList ($script:selectedCert.StorePath)
                $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
                
                # Find the matching cert to delete
                $matches = $store.Certificates | Where-Object { $_.Thumbprint -eq $script:selectedCert.Thumbprint }
                if ($matches) {
                    foreach ($m in $matches) {
                        $store.Remove($m)
                    }
                    $store.Close()
                    Show-Dialog -Title "Deleted" -Message "Certificate deleted successfully." -Type "Info"
                    Load-StoreCertificates $script:selectedStorePath
                } else {
                    $store.Close()
                    Show-Dialog -Title "Not Found" -Message "Could not find the certificate in the store." -Type "Error"
                }
            } catch {
                Show-Dialog -Title "Error" -Message "Failed to delete certificate: $($_.Exception.Message)`n`nNote: Administrator privileges may be required to delete certificates from local machine stores." -Type "Error"
            }
        }
    }
})

# Initial dashboard population
Update-Dashboard

# Show Main Window
$window.ShowDialog() | Out-Null
