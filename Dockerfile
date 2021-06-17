FROM python:3.5
ARG ROOT_DIR=/app/

#ENV PATH $PATH:${PYTHONUSERBASE}:${PYTHONUSERBASE}/bin/:${PYTHONUSERBASE}/lib/python3.5/site-packages/
#ENV PATH $PATH:/home/ticking_user/.local/bin
# home/ticking_user/.local/lib/python3.5/site-packages/unipath/abstractpath.py

# Create non-privileged user
RUN groupadd -g 999 exec_group&& \
    useradd -r -u 999 -g exec_group exec_user

# Copy app code
WORKDIR ${ROOT_DIR}
ADD . ${ROOT_DIR}
RUN chown -R exec_user:exec_group .

# Requirements
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

USER exec_user

#RUN rm secrets.env

ENTRYPOINT gunicorn --bind 0.0.0.0:8080 --log-level 'debug' wsgi:app