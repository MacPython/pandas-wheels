####################
pandas wheel builder
####################

Repository to build OSX wheels for pandas.

The usual behavior of the repo is to build the wheel corresponding to the most
recent git tag (see `git-closest-tag
<https://github.com/MacPython/terryfy/blob/master/git-closest-tag>`_.

To build a particular commit instead:

* comment out the line ``global: LATEST_TAG=1`` in the ``.travis.yml`` file.

* Update pandas with version you want to build:

    * cd pandas && git pull && git checkout DESIRED_TAG
    * cd .. && git add pandas

where "DESIRED_TAG" is a pandas git tag like "2.3.0"

The wheels get uploaded to a `rackspace container
<http://a365fff413fe338398b6-1c8a9b3114517dc5fe17b7c3f8c63a43.r19.cf2.rackcdn.com>`_
to which we the MacPython owners have the API key.  The API key is encrypted to
this exact repo in the ``.travis.yml`` file, so the upload won't work for you
from another repo.  You can contact the MacPython team to get set up, by using
the github issues for this project, or use another upload service such as github
-- see for example Jonathan Helmus' `sckit-image wheels builder <https://github.com/jjhelmus/scikit-image-ci-wheel-builder>`_
