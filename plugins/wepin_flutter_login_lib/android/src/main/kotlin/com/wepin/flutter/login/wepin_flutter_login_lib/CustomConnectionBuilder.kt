package com.wepin.flutter.login.wepin_flutter_login_lib

import android.net.Uri
import java.io.IOException
import java.net.HttpURLConnection
import java.util.concurrent.TimeUnit

/*
* Copyright 2016 The AppAuth for Android Authors. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
* in compliance with the License. You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software distributed under the
* License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing permissions and
* limitations under the License.
*/ /**
 * An implementation of [ConnectionBuilder] that permits
 * to set custom headers on connection use to request endpoints.
 * Useful for non-spec compliant oauth providers.
 */
class CustomConnectionBuilder(connectionBuilderToUse: net.openid.appauth.connectivity.ConnectionBuilder) :
    net.openid.appauth.connectivity.ConnectionBuilder {
    private var headers: Map<String, String>? = null
    private var connectionTimeoutMs = TimeUnit.SECONDS.toMillis(15).toInt()
    private var readTimeoutMs = TimeUnit.SECONDS.toMillis(10).toInt()
    private val connectionBuilder: net.openid.appauth.connectivity.ConnectionBuilder

    init {
        connectionBuilder = connectionBuilderToUse
    }

    fun setHeaders(headersToSet: Map<String, String>?) {
        headers = headersToSet
    }

    fun setConnectionTimeout(timeout: Int) {
        connectionTimeoutMs = timeout
        readTimeoutMs = timeout
    }

    @Throws(IOException::class)
    override fun openConnection(uri: Uri): HttpURLConnection {
        val conn: HttpURLConnection = connectionBuilder.openConnection(uri)
        if (headers != null) {
            for ((key, value) in headers!!) {
                conn.setRequestProperty(key, value)
            }
        }
        conn.connectTimeout = connectionTimeoutMs
        conn.readTimeout = readTimeoutMs
        return conn
    }
}