class volume_attach::backup (
    $dev 		  = '/dev/xvdl',
    $config_file_template = 'volume_attach/volume_attach_backup.erb',
    $options_hash         = {},
)   {

    include ec2

    file { '/etc/init.d/volume_attach_backup':
     	content => template($config_file_template),
	require => Class['ec2'],
        owner   => 'root',
        group   => 'root',
        mode    => 755,
    }

    service { 'volume_attach_backup':
	ensure    => undef,
	enable    => true,
	hasstatus => false,
	require   => File['/etc/init.d/volume_attach_backup'],
    }

    exec { 'volume_attach_backup':
	command => '/etc/init.d/volume_attach_backup',
	path    => "/usr/bin:/usr/sbin:/bin",
	unless  => "grep ${dev} /proc/mounts",
    }

}
