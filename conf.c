/*
 *  conf.c
 *
 *  Copyright (c) 2006-2025 Pacman Development Team <pacman-dev@lists.archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
#include <stdio.h>
#include <alpm.h>


/** Sets up libalpm global stuff in one go. Called after the command line
 * and initial config file parsing. Once this is complete, we can see if any
 * paths were defined. If a rootdir was defined and nothing else, we want all
 * of our paths to live under the rootdir that was specified. Safe to call
 * multiple times (will only do anything the first time).
 */

static int setup_libalpm(void)
{
	int ret = 0;
	alpm_errno_t err;
	alpm_handle_t *handle;
	alpm_list_t *i;
	pm_printf(ALPM_LOG_DEBUG, "setup_libalpm called\n");
	/* initialize library */
	handle = alpm_initialize(config->rootdir, config->dbpath, &err);
	if(!handle) {
		pm_printf(ALPM_LOG_ERROR, _("failed to initialize alpm library:\n(root: %s, dbpath: %s)\n%s\n"),
		        config->rootdir, config->dbpath, alpm_strerror(err));
		if(err == ALPM_ERR_DB_VERSION) {
			fprintf(stderr, _("try running pacman-db-upgrade\n"));
		}
		return -1;
	}
	config->handle = handle;
	alpm_option_set_logcb(handle, cb_log, NULL);
	alpm_option_set_dlcb(handle, cb_download, NULL);
	alpm_option_set_eventcb(handle, cb_event, NULL);
	alpm_option_set_questioncb(handle, cb_question, NULL);
	alpm_option_set_progresscb(handle, cb_progress, NULL);
	if(config->op == PM_OP_FILES) {
		alpm_option_set_dbext(handle, ".files");
	}
	ret = alpm_option_set_logfile(handle, config->logfile);
	if(ret != 0) {
		pm_printf(ALPM_LOG_ERROR, _("problem setting logfile '%s' (%s)\n"),
				config->logfile, alpm_strerror(alpm_errno(handle)));
		return ret;
	}
	/* Set GnuPG's home directory. This is not relative to rootdir, even if
	 * rootdir is defined. Reasoning: gpgdir contains configuration data. */
	ret = alpm_option_set_gpgdir(handle, config->gpgdir);
	if(ret != 0) {
		pm_printf(ALPM_LOG_ERROR, _("problem setting gpgdir '%s' (%s)\n"),
				config->gpgdir, alpm_strerror(alpm_errno(handle)));
		return ret;
	}
	/* Set user hook directory. This is not relative to rootdir, even if
	 * rootdir is defined. Reasoning: hookdir contains configuration data. */
	/* add hook directories 1-by-1 to avoid overwriting the system directory */
	for(i = config->hookdirs; i; i = alpm_list_next(i)) {

		if((ret = alpm_option_add_hookdir(handle, i->data)) != 0) {
			pm_printf(ALPM_LOG_ERROR, _("problem adding hookdir '%s' (%s)\n"),
					(char *) i->data, alpm_strerror(alpm_errno(handle)));
			return ret;
		}
	}
	alpm_option_set_cachedirs(handle, config->cachedirs);
	alpm_option_set_overwrite_files(handle, config->overwrite_files);
	alpm_option_set_default_siglevel(handle, config->siglevel);
	alpm_option_set_local_file_siglevel(handle, config->localfilesiglevel);
	alpm_option_set_remote_file_siglevel(handle, config->remotefilesiglevel);
	for(i = config->repos; i; i = alpm_list_next(i)) {
		register_repo(i->data);
	}
	if(config->xfercommand) {
		alpm_option_set_fetchcb(handle, download_with_xfercommand, NULL);
	} else if(!(alpm_capabilities() & ALPM_CAPABILITY_DOWNLOADER)) {
		pm_printf(ALPM_LOG_WARNING, _("no '%s' configured\n"), "XferCommand");
	}
	alpm_option_set_architectures(handle, config->architectures);
	alpm_option_set_checkspace(handle, config->checkspace);
	alpm_option_set_usesyslog(handle, config->usesyslog);
	if(config->sandboxuser) {
		alpm_option_set_sandboxuser(handle, config->sandboxuser);
	}
	alpm_option_set_disable_sandbox(handle, config->disable_sandbox);
	alpm_option_set_ignorepkgs(handle, config->ignorepkg);
	alpm_option_set_ignoregroups(handle, config->ignoregrp);
	alpm_option_set_noupgrades(handle, config->noupgrade);
	alpm_option_set_noextracts(handle, config->noextract);
	alpm_option_set_disable_dl_timeout(handle, config->disable_dl_timeout);
	alpm_option_set_parallel_downloads(handle, config->parallel_downloads);
	for(i = config->assumeinstalled; i; i = i->next) {
		char *entry = i->data;
		alpm_depend_t *dep = alpm_dep_from_string(entry);
		if(!dep) {
			return 1;
		}
		pm_printf(ALPM_LOG_DEBUG, "parsed assume installed: %s %s\n", dep->name, dep->version);
		ret = alpm_option_add_assumeinstalled(handle, dep);
		alpm_dep_free(dep);
		if(ret) {
			pm_printf(ALPM_LOG_ERROR, _("Failed to pass %s entry to libalpm"), "assume-installed");
			return ret;
		}
	 }
	return 0;
}

int main(void){
	return setup_libalpm();
}
