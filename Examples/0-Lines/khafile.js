var project = new Project('Lines');

project.addAssets('Assets/**');

project.addSources('Sources');
project.addSources('../../Sources');

return project;