import { Router } from 'express';
import { createRouter, guest } from '@backstage/plugin-auth-backend';
import { github } from '@backstage/plugin-auth-backend-module-github-provider';
import { PluginEnvironment } from '../types';

export default async function createPlugin(env: PluginEnvironment): Promise<Router> {
  return createRouter({
    env,
    providers: {
      github: github.create({
        signIn: {
          resolver: async ({ fullProfile }) => {
            const username = fullProfile.username || 'github-user';
            return {
              result: {
                type: 'user',
                userEntityRef: `user:default/${username}`,
              },
            };
          },
        },
      }),
      guest: guest.create({
        signIn: {
          resolver: async () => ({
            result: {
              type: 'user',
              userEntityRef: 'user:default/guest',
            },
          }),
        },
      }),
    },
  });
}
