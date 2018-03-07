SimpleCov.start do
    add_filter ['/test/', '/features/', '/spec/']

    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
    add_group 'Libs', 'lib'
    add_group 'Views', 'app/views'
    add_group 'Helpers', 'app/helpers'
    add_group 'Services', 'app/services'
    add_group 'Config', 'config'
    add_group 'Mailers', 'app/mailers'
    add_group 'Jobs', 'app/jobs'
end