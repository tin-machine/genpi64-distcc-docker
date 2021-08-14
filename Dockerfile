FROM gentoo/portage AS portage
FROM gentoo/stage3-amd64 AS distcc-builder
COPY --from=portage /var/db/repos/gentoo/ /var/db/repos/gentoo/
RUN emerge --update --deep --newuse --with-bdeps=y @system
RUN emerge sys-devel/distcc sys-devel/crossdev
RUN mkdir -p /etc/portage/repos.conf
COPY crossdev.conf /etc/portage/repos.conf/
RUN mkdir -p /usr/local/portage-crossdev &&\
  crossdev --stable -t aarch64-unknown-linux-gnu --init-target -oO /usr/local/portage-crossdev &&\
  echo 'thin-manifests = true' >> /usr/local/portage-crossdev/metadata/layout.conf &&\
  echo 'cross-aarch64-unknown-linux-gnu/gcc cxx multilib fortran -mudflap nls openmp -sanitize -vtv' >> /etc/portage/package.use/crossdev  &&\
  crossdev --stable -t aarch64-unknown-linux-gnu -oO /usr/local/portage-crossdev &&\
  cd /usr/aarch64-unknown-linux-gnu/etc/portage &&\
  rm -f make.profile &&\
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/desktop make.profile
COPY hello.c /
COPY boot.bash /boot.bash
EXPOSE 3632

CMD ["distccd" "--daemon" "--no-detach" "--log-level" "notice" "--log-stderr" "--allow-private"]
