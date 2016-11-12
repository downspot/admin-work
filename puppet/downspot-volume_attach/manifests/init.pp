class volume_attach (
    $config_file_template = 'volume_attach/volume_attach.erb',
    $options_hash         = {},
)   {

    include ec2

    file { '/etc/init.d/volume_attach':
     	content => template($config_file_template),
	require => Class['ec2'],
        owner   => 'root',
        group   => 'root',
        mode    => 755,
    }

    service { 'volume_attach':
	ensure    => undef,
	enable    => true,
	hasstatus => false,
	require   => File['/etc/init.d/volume_attach'],
    }

    exec { 'volume_attach':
	command => '/etc/init.d/volume_attach',
	path    => "/usr/bin:/usr/sbin:/bin",
	onlyif  => 'test `grep "/dev/xvdk" /proc/mounts | wc -l` == "0"',
    }

}
